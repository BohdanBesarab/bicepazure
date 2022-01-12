import java.time.*
import java.time.format.DateTimeFormatter


def call (String appName) {
def tag = VersionNumber (versionNumberString: '${BUILD_DATE_FORMATTED, "yyyy.M"}.${BUILD_NUMBER}')
    sh "az artifacts universal publish --organization https://dev.azure.com/bohdanbesarab/ --project eleksCamp --scope project --feed jenkins --name ${appName} --version ${tag} --path ${WORKSPACE}/app.zip"
}