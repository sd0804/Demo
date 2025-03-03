pipeline {
   agent any
     tools {
            maven 'Maven3' // This must match the name configured in Global Tool Configuration
        }
    environment {
        PROJECT_ID = 'nifty-jet-445804-n1'
        REGION = 'us-central1'
        CLUSTER_NAME = 'autopilot-cluster-1'
        IMAGE_NAME = "gcr.io/${PROJECT_ID}/demo:latest"
        DOCKER_ARGS = "-v /var/run/docker.sock:/var/run/docker.sock"
    }
    stages {
        stage('Checkout') {
            steps {
                // Clone the repository
                git 'https://github.com/sd0804/Demo.git'
            }
        }
        stage('Build Application') {
            steps {
                // Build the Spring Boot app with Maven
                sh 'mvn clean package'
            }
        }
        stage('Build Docker Image') {
             steps {
                            script {
                                // Use the official Docker image (which includes the Docker CLI)
                                def dockerImage = docker.image('docker:latest')
                                // Run Docker commands inside a container with the host Docker socket mounted
                                dockerImage.inside(env.DOCKER_ARGS) {
                                    sh "docker build -t ${env.IMAGE_NAME} ."
                                }
                            }
                        }
        }
        stage('Push Docker Image to GCR') {
           steps {
                           script {
                               def dockerImage = docker.image('docker:latest')
                               dockerImage.inside(env.DOCKER_ARGS) {
                                   // Configure authentication to push to GCR
                                   sh 'gcloud auth configure-docker'
                                   sh "docker push ${env.IMAGE_NAME}"
                               }
                           }
                       }
        }
        stage('Deploy to GKE') {
            steps {
                // Get credentials for the GKE cluster
                sh "gcloud container clusters get-credentials ${CLUSTER_NAME} --region ${REGION} --project ${PROJECT_ID}"
                // Update the deployment with the new image (assumes deployment name is 'demo-deployment')
                sh "kubectl set image deployment/demo-deployment demo=${IMAGE_NAME}"
                // Optionally, wait for rollout to complete
                sh "kubectl rollout status deployment/demo-deployment"
            }
        }
    }
}
