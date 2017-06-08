def imageUrl = "quay.io/assemblyline/ok"

podTemplate(
  label: 'build',
  containers: [
    containerTemplate(name: 'docker', image: 'docker:1.11.1', command: 'cat', ttyEnabled: true),
    containerTemplate(name: 'golang', image: 'golang:1.8.3', command: 'cat', ttyEnabled: true),
  ],
  volumes:[
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
  ],
) {
  node('build') {
    stage('checkout')     { checkout scm }

    stages = [:]

    stages['build'] = { container('golang') { sh "go build -ldflags -s ok.go" } }
    stages['test']  = { container('golang') { sh "go vet" } }

    parallel stages

    stage('docker build') { container('docker') { sh "docker build -t ${imageUrl} ." } }

    //only deploy master branch to quay repo
    if (env.BRANCH_NAME == 'master') {
      stage('docker push') {
        container('docker') {
          withCredentials([usernamePassword(credentialsId: 'quay-assemblyline-susan', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
            sh """
              docker login -u=$USERNAME -p=$PASSWORD quay.io
              docker push ${imageUrl}
            """
          }
        }
      }
    }
  }
}
