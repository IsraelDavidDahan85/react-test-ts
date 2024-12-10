pipeline {
    agent {
        label "npm-node-agent"
    }

    stages {

        stage('Git SCM') {
            steps {
                // Get some code from a GitHub repository
                git branch: 'main', url: 'https://github.com/IsraelDavidDahan85/react-test-ts.git'
            }

            post {
                // If Maven was able to run the tests, even if some of the test
                // failed, record the test results and archive the jar file.
                success {
                    script {
                        sh 'echo successfully build'
                    }
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    sh 'npm install && npm run test run'
                
                }
            }
        }
        stage('Build') {
            agent {
                label "docker"
            }
            steps {
                script {
                    sh '''
                    docker build -t react-test-ts .
                    '''
                }
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
                    sh 'docker tag react-test-ts $DOCKER_USER/react-test-ts:$BUILD_NUMBER'
                    sh 'docker tag react-test-ts $DOCKER_USER/react-test-ts:latest'

                    sh 'docker push $DOCKER_USER/react-test-ts:$BUILD_NUMBER'
                    sh 'docker push $DOCKER_USER/react-test-ts:latest'
                }

            }
        }
        stage('Tag') {
            steps {
                script {
                    // save private key to file 
                    withCredentials([sshUserPrivateKey(credentialsId: 'github', keyFileVariable: 'privateKey')]) {
                        writeFile file: 'key', text: privateKey
                    }

                    // add github to known hosts
                    sh 'ssh-keyscan github.com >> ~/.ssh/known_hosts'

                    // tag the commit
                    sh '''
                    git config --global user.email "israeldaviddahan@gmail.com"
                    git config --global user.name "Israel David Dahan"

                    git tag -a v1.0.$BUILD_NUMBER -m "Version 1.0.$BUILD_NUMBER"
                    git push origin v1.0.$BUILD_NUMBER
                    '''
                }
            }
        }


    }
}
