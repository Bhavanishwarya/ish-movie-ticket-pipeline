pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'ish-movie-ticket-booking:1.0'
    }

    stages {

        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/Bhavanishwarya/ish-movie-ticket-pipeline.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t %DOCKER_IMAGE% ."
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
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
                // Use kubeconfig credentials stored in Jenkins
                withCredentials([file(credentialsId: 'kubeconfig-docker-desktop', variable: 'KUBECONFIG_FILE')]) {
                    bat """
                        echo Deploying application to Kubernetes...
                        set KUBECONFIG=%KUBECONFIG_FILE%
                        kubectl config get-contexts
                        kubectl apply -f ish-movie-ticket-deployment.yaml --validate=false
                        kubectl apply -f ish-movie-ticket-service.yaml --validate=false
                        kubectl get pods
                    """
                }
            }
        }
    }
}
