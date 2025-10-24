pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'bhavanishwarya/ish-movie-ticket-booking:1.0'
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Bhavanishwarya/ish-movie-ticket-pipeline.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t %DOCKER_IMAGE% ."
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials',
                                                  usernameVariable: 'DOCKER_USER',
                                                  passwordVariable: 'DOCKER_PASS')]) {
                    bat 'docker login -u %DOCKER_USER% -p %DOCKER_PASS%'
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                bat "docker push %DOCKER_IMAGE%"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG_FILE')]) {
                    bat """
                        echo Deploying application to Kubernetes...
                        set KUBECONFIG=%KUBECONFIG_FILE%
                        kubectl get nodes
                        kubectl apply -f ish-movie-ticket-deployment.yaml --validate=false
                        kubectl apply -f ish-movie-ticket-service.yaml --validate=false
                        echo Deployment complete.
                        kubectl get pods
                    """
                }
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully! Application deployed to Kubernetes.'
        }
        failure {
            echo '❌ Pipeline failed. Please check the logs above for details.'
        }
    }
}
