def call () {
    sh 'dotnet publish -c Release -o ./publish'
    zip zipFile: 'app.zip' 
        dir: 'publish'
    withCredentials([string(credentialsId: 'azure-pat', variable: 'PAT')]){
    sh 'az extension add --name azure-devops'
        sh 'echo $PAT | az devops login --organization https://dev.azure.com/bohdanbesarab/'
    } 

}