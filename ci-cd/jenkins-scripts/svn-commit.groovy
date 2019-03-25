node {
    stage 'Check Changes'
    echo "Repo: " + REPO + " / Revision: " + REV
    sh '''
        # -----------------------------------------------
        # Init

        set -e
        rm -rf ..?* .[!.]* *
        export REPO=${REPO}
        export SERVER_PROXY='http://proxy-nginx'
        export STAGE=dev


        # -----------------------------------------------
        # Functions


        # Get Source Code
        cloneRepo()
        {
            svn checkout \${SERVER_PROXY}/svn/\${REPO} \\
                --non-interactive --no-auth-cache --username admin --password admin
        }


        # Get Local Hash
        getFolderHash()
        {
            FOLDER=\$1
            cd \${FOLDER}
            HASH=\$(find . -type f -exec md5sum {} \\; | sort -k 2 | md5sum)
            echo \${HASH}
        }


        # Get Artefact Hash
        getArtefactHash()
        {
            SERVICE=\$1
            echo "" > .tmp
            curl -s -f \\
              -u admin:admin123 \\
              \${SERVER_PROXY}/nexus/content/repositories/services/${SERVICE}-builds > .tmp || true
            tail -n1 .tmp | cut -d"|" -f3  | head -n1 || echo ""
            rm -f .tmp
        }


        # Get Artefact Version
        getArtefactVersion()
        {
            SERVICE=\$1
            echo "" > .tmp
            curl -s -f \\
              -u admin:admin123 \\
              \${SERVER_PROXY}/nexus/content/repositories/services/${SERVICE}-builds > .tmp || true
            tail -n1 .tmp | cut -d"|" -f3  | head -n1 || echo ""
            rm -f .tmp
        }


        # -----------------------------------------------
        # Scan Sequence

        cloneRepo

        cd \${REPO}
        echo "" > to_build

        for SERVICE_FOLDER in \$(cat info/services-\${STAGE} | cut -d"=" -f1); do

          SERVICE=$(cat \${SERVICE_FOLDER}/info | grep name= | cut -f2 -d"=")

          LOCAL_VERSION=$(cat \${SERVICE_FOLDER}/info | grep version= | cut -f2 -d"=")
          LOCAL_HASH=\$(getFolderHash "\$(pwd)/\${SERVICE_FOLDER}")
          echo \${LOCAL_HASH} > \$(pwd)/\${SERVICE_FOLDER}/.hash

          ARTIFACT_HASH=\$(getArtefactHash \${SERVICE})
          ARTIFACT_VERSION=\$(getArtefactVersion \${SERVICE})

          echo "\${SERVICE}: \${LOCAL_HASH} vs \${ARTIFACT_HASH}"

          if [ "\${LOCAL_HASH}" != "\${ARTIFACT_HASH}" ]; then
            if [ "\${LOCAL_VERSION}" = "\${ARTIFACT_VERSION}" ]; then
              echo "ERROR: Service changed but version is the same"
              exit 1
            fi
            echo ">>> New version for \${SERVICE_FOLDER}"
            echo \${SERVICE_FOLDER} >> to_build
          fi

        done
    '''

    services = readFile(REPO + '/to_build').trim().split('\n')
    for (i=0 ; i<services.length ; i++) {
      if (services[i] != '') {
        build job: 'build-service', parameters: [string(name: 'SERVICE_DIR', value: pwd() + '/' + REPO + '/' + services[i])]
      }
    }


    stage 'Service Description'
    sh '''
        # -----------------------------------------------
        # Init

        SERVER_PROXY='http://proxy-nginx'


        # -----------------------------------------------
        # Upload

        cd ${REPO}


        mkdir -p ./info
        touch ./info/services-dev
        touch ./info/services-staging
        touch ./info/services-prod
        curl -v -s \
            -u admin:admin123 \
            --upload-file ./info/services-dev \
            ${SERVER_PROXY}/nexus/content/repositories/services/services-dev
        curl -v -s \
            -u admin:admin123 \
            --upload-file ./info/services-staging \
            ${SERVER_PROXY}/nexus/content/repositories/services/services-staging
        curl -v -s \
            -u admin:admin123 \
            --upload-file ./info/services-prod \
            ${SERVER_PROXY}/nexus/content/repositories/services/services-prod
    '''
}
