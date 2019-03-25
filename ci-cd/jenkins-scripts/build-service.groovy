node {
    stage 'Build Service'
    echo 'Folder: ' + SERVICE_DIR
    sh '''
        # -----------------------------------------------
        # Init
        set -e
        rm -rf ..?* .[!.]* *
        cp -R ${SERVICE_DIR} service
        cd service
        export BUILDER_FOLDER=/var/jenkins_home
        export SERVER_PROXY='http://proxy-nginx'
        export STAGE=dev
        export DOCKER_REGISTRY=\${DOCKER_DTR_HOST}
        export REGISTRY_NAMESPACE=dev
        export SERVICE=$(cat info | grep name= | cut -f2 -d"=")
        export SERVICE_VERSION=$(cat info | grep version= | cut -f2 -d"=")


        # -----------------------------------------------
        # Start Builder
        SERVICE_TYPE=\$(cat info | grep type | cut -d"=" -f2)
        # if [ \"\${BUILDER_NAME}\" = \"null\" ]; then
        #  exit 0
        # fi
        # docker rm -f jenkins_builder_\${BUILDER_NAME} || true
        # docker build -f \${BUILDER_FOLDER}/Dockerfile-builder-\${BUILDER_NAME} -t \${BUILDER_NAME} .
        # docker run --name jenkins_builder_\${BUILDER_NAME} -d \${BUILDER_NAME}


        # -----------------------------------------------
        # Build
        docker-compose build


        # -----------------------------------------------
        # Extract Images Locally
        SERVICE_IMAGES=""
        rm -fr .images
        mkdir .images
        touch .images/list
        I=0
        for IMAGE in \$(docker images | grep "\${REGISTRY_NAMESPACE}/\${SERVICE} " | grep " \${SERVICE_VERSION} " | tr -s " " | cut -d" " -f1,2 | sed -e "s/ /:/"); do
            I=$(( ${I} + 1 ))
            echo \${IMAGE} >> .images/list
            docker save \${IMAGE} > .images/${I}.tar
            SERVICE_IMAGES="${SERVICE_IMAGES}${IMAGE};"
        done


        # -----------------------------------------------
        # Import and push to DTR
        cd /var/jenkins_home/ucp-bundle-admin
        . ./env.sh
        cd -
        docker login \${DOCKER_DTR_HOST} -u admin -p password_demo
        I=0
        for IMAGE in \$(cat .images/list); do
            I=$(( ${I} + 1 ))
            docker load < .images/${I}.tar
            docker push ${IMAGE}
        done
        rm -fr .images


        # -----------------------------------------------
        # Update Build Info
        touch service-builds
        curl -s -f \
            -u admin:admin123 \
            ${SERVER_PROXY}/nexus/content/repositories/services/${SERVICE}-builds \
            > service-builds || true
        echo "|${SERVICE_VERSION}|$(cat .hash)|${SERVICE_IMAGES}|" >> service-builds
        curl -v -s \
            -u admin:admin123 \
            --upload-file service-builds \
            ${SERVER_PROXY}/nexus/content/repositories/services/${SERVICE}-builds
        rm -fr service-builds
        cd ..
        mv service ${SERVICE}_${SERVICE_VERSION}
        tar czf ${SERVICE}_${SERVICE_VERSION}.tar.gz ${SERVICE}_${SERVICE_VERSION}
        curl -v -s \
            -u admin:admin123 \
            --upload-file ${SERVICE}_${SERVICE_VERSION}.tar.gz \
            ${SERVER_PROXY}/nexus/content/repositories/services/${SERVICE}_${SERVICE_VERSION}.tar.gz


        # -----------------------------------------------
        # Cleanup
        rm -rf ..?* .[!.]* *
    '''
}
