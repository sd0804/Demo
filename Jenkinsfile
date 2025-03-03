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
                // Build the Docker image using the Dockerfile in the repo
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }
        stage('Push Docker Image to GCR') {
            steps {
                // Authenticate Docker to GCR (if not already configured)
                sh 'gcloud auth configure-docker'
                // Push the image to GCR
                sh "docker push ${IMAGE_NAME}"
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
