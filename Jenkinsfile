def repoUrl = "quay.io/assemblyline/ok"
def baseImageURL = repoUrl

podTemplate(
  label: 'build',
  containers: [
    containerTemplate(name: 'docker', image: 'docker', command: 'cat', ttyEnabled: true),
  ],
  volumes:[
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
  ],
) {
  node('build') {
    stage('checkout')     {
      gitSHA = checkout(scm).GIT_COMMIT
    }

    stage('docker build') {
      baseImageURL = "${repoUrl}:${gitSHA}-${env.BUILD_ID}"
      container('docker') {
        withCredentials([usernamePassword(credentialsId: 'quay-assemblyline-susan', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
          sh """
            docker login -u=$USERNAME -p=$PASSWORD quay.io
            docker build -t ${baseImageURL}-dev   --target=dev   .
            docker build -t ${baseImageURL}-build --target=build .
            docker build -t ${baseImageURL}-prod  --target=prod  .
            docker push ${baseImageURL}-dev
            docker push ${baseImageURL}-build
            docker push ${baseImageURL}-prod
          """
        }
      }
    }
  }
}

podTemplate(
  label: 'test',
  containers: [containerTemplate(name: 'ok', image: "${baseImageURL}-build", command: 'cat', ttyEnabled: true)],
) {
  node('test') {
    stage('vet') { container('ok') {
      sh """
        cd /go/src/github.com/assemblyline/ok
        go vet
      """
    } }
  }
}
