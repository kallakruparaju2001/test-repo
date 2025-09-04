pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub-creds') 
        USERNAME = "${DOCKER_HUB_CREDENTIALS_USR}"
        PASSWORD = "${DOCKER_HUB_CREDENTIALS_PSW}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    // Get short commit ID
                    def commitId = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    def envName = ""

                    if (env.BRANCH_NAME == "dev") {
                        envName = "dev"
                    } else if (env.BRANCH_NAME == "prod") {
                        envName = "prod"
                    } else {
                        error("This pipeline only builds images for dev and prod branches")
                    }

                    sh """
                        chmod +x ./build.sh
                        USERNAME=$USERNAME PASSWORD=$PASSWORD ENV=${envName} TAG=${commitId} ./build.sh
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Docker image pushed: ${env.BRANCH_NAME} branch → $USERNAME/react-app:${env.BRANCH_NAME}-${env.GIT_COMMIT[0..6]}"
        }
        failure {
            echo "Docker image build/push failed for branch ${env.BRANCH_NAME}"
        }
    }
}

