node {
    stage 'Build Service'
    sh '''
        # -----------------------------------------------
        # Init

        set -e
        rm -rf ..?* .[!.]* *
        export SERVER_PROXY='http://proxy-nginx'
        export STAGE=dev
        export DOCKER_REGISTRY=\${DOCKER_DTR_HOST}
        export REGISTRY_NAMESPACE=dev


        # -----------------------------------------------
        # Functions


        # Get Source Code
        isLowerVersion()
        {
            echo $1 > .tmp
            echo $2 >> .tmp
            sort -V .tmp > .tmp_true
            if [ "$(diff .tmp .tmp_true | wc -l)" = "0" ]; then
                echo "Y"
            else
                echo "N"
            fi
            rm -f .tmp .tmp_true
        }


        # Deploy a service
        deployDockerService()
        {
            SERVICE=$1
            SERVICE_VERSION=$2
            rm -fr .tmp
            mkdir .tmp
            cd .tmp
            curl -s -f \
                -u admin:admin123 \
                \${SERVER_PROXY}/nexus/content/repositories/services/\${SERVICE}_\${SERVICE_VERSION}.tar.gz \
                -o \${SERVICE}_\${SERVICE_VERSION}.tar.gz
            tar xzf \${SERVICE}_\${SERVICE_VERSION}.tar.gz
            cd \${SERVICE}_\${SERVICE_VERSION}
            export SERVICE=\${SERVICE}
            export SERVICE_VERSION=\${SERVICE_VERSION}

            if [ -f ./kube-deploy-${STAGE}.yml ]; then
                cat ./kube-deploy-${STAGE}.yml \
                    | sed "s/\${SERVICE}/${SERVICE}/g" \
                    | sed "s/\${SERVICE_VERSION}/${SERVICE_VERSION}/g" \
                    | sed "s/\${DOCKER_REGISTRY}/${DOCKER_REGISTRY}/g" \
                    | sed "s/\${REGISTRY_NAMESPACE}/${REGISTRY_NAMESPACE}/g" \
                    | sed "s/\${VOLUMES_BASE_DIR}/${VOLUMES_BASE_DIR_ESCAPED}/g" \
                    | sed "s/\${STAGE}/${STAGE}/g" > .tmp_kube-deploy.yml
                kubectl apply -f .tmp_kube-deploy.yml
                rm -f .tmp_kube-deploy.yml

            elif [ -f ./kube-deploy.yml ]; then
                cat ./kube-deploy.yml \
                    | sed "s/\${SERVICE}/${SERVICE}/g" \
                    | sed "s/\${SERVICE_VERSION}/${SERVICE_VERSION}/g" \
                    | sed "s/\${DOCKER_REGISTRY}/${DOCKER_REGISTRY}/g" \
                    | sed "s/\${REGISTRY_NAMESPACE}/${REGISTRY_NAMESPACE}/g" \
                    | sed "s/\${VOLUMES_BASE_DIR}/${VOLUMES_BASE_DIR_ESCAPED}/g" \
                    | sed "s/\${STAGE}/${STAGE}/g" > .tmp_kube-deploy.yml
                kubectl apply -f .tmp_kube-deploy.yml
                rm -f .tmp_kube-deploy.yml

            elif [ -f ./docker-compose-${STAGE}.yml  ]; then
                docker stack deploy --compose-file docker-compose-${STAGE}.yml \${SERVICE}
                
            else
                docker stack deploy --compose-file docker-compose.yml \${SERVICE}
            fi
        }


        # -----------------------------------------------
        # Login to DTR
        cd /var/jenkins_home/ucp-bundle-admin
        . ./env.sh
        cd -
        docker login \${DOCKER_DTR_HOST} -u admin -p password_demo


        # -----------------------------------------------
        # List services

        curl -s -f \
            -u admin:admin123 \
            \${SERVER_PROXY}/nexus/content/repositories/services/services-\${STAGE} \
            > services

        for SERVICE_DEFINITION in \$(cat services); do

            # Find latest compatible version
            SERVICE=$(echo \${SERVICE_DEFINITION} | sed 's/\\(.*\\)\\/\\(.*\\)=\\(.*\\)/\\2/')
            SERVICE_MAX_VERSION=$(echo \${SERVICE_DEFINITION} | sed 's/\\(.*\\)\\/\\(.*\\)=\\(.*\\)/\\3/')
            curl -s -f \
                -u admin:admin123 \
                \${SERVER_PROXY}/nexus/content/repositories/services/\${SERVICE}-builds \
                > service-builds

            LATEST_COMPATIBLE_BUILD=""

            while read -r SERVICE_BUILD; do
                if [ "$(isLowerVersion $(echo ${SERVICE_BUILD} | cut -d"|" -f2) ${SERVICE_MAX_VERSION})" = "Y" ]; then
                    LATEST_COMPATIBLE_BUILD=${SERVICE_BUILD}
                fi
            done < "service-builds"

            # Deploy service
            if [ "\${LATEST_COMPATIBLE_BUILD}" != "" ]; then
                deployDockerService \${SERVICE} $(echo ${LATEST_COMPATIBLE_BUILD} | cut -f2 -d"|")
            fi
        done


        # -----------------------------------------------
        # Cleanup
        rm -rf ..?* .[!.]* *
    '''
}
