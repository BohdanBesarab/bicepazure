def call (String appName) {
    sh "az artifacts universal publish --organization https://dev.azure.com/bohdanbesarab/ --project eleksCamp --scope project --feed jenkins --name ${appName} --version 1.0.${currentBuild.number} --path ${WORKSPACE}/app.zip"
}