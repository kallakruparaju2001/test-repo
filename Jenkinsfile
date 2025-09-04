pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub-creds')  // Jenkins stored creds
        COMMIT_ID = sh(returnStdout: true, script: "git rev-parse --short HEAD").trim()
    }

    options {
        skipDefaultCheckout(false)  // ensure repo is checked out
    }

    triggers {
        // GitHub Webhook trigger
        githubPush()
    }

    parameters {
        choice(
            name: 'TARGET_ENV',
            choices: ['auto', 'dev', 'prod'],
            description: 'Select environment (auto = detect from branch)'
        )
    }

    stages {
        stage('Login to Docker Hub') {
            steps {
                script {
                    sh "echo ${DOCKER_HUB_CREDENTIALS_PSW} | docker login -u ${DOCKER_HUB_CREDENTIALS_USR} --password-stdin"
                }
            }
        }

        stage('Build & Push Image') {
            steps {
                script {
                    def branch = env.GIT_BRANCH ?: sh(returnStdout: true, script: "git rev-parse --abbrev-ref HEAD").trim()
                    def targetEnv = params.TARGET_ENV

                    if (targetEnv == "auto") {
                        if (branch == "origin/main" || branch == "main") {
                            targetEnv = "prod"
                        } else if (branch == "origin/dev" || branch == "dev") {
                            targetEnv = "dev"
                        } else {
                            error("Branch ${branch} is not mapped to an environment")
                        }
                    }

                    echo "Deploying to environment: ${targetEnv}"

                    def repoName = (targetEnv == "prod") ? "myapp-prod" : "myapp-dev"
                    def imageName = "${DOCKER_HUB_CREDENTIALS_USR}/${repoName}:${COMMIT_ID}"

                    // Build with docker-compose
                    sh """
                        USERNAME=${DOCKER_HUB_CREDENTIALS_USR} ENV=${targetEnv} TAG=${COMMIT_ID} \
                        docker-compose -f docker-compose.build.yml build
                    """

                    // Push with docker-compose
                    sh """
                        USERNAME=${DOCKER_HUB_CREDENTIALS_USR} ENV=${targetEnv} TAG=${COMMIT_ID} \
                        docker-compose -f docker-compose.build.yml push
                    """

                    echo "Image pushed: ${imageName}"
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
    }
}

