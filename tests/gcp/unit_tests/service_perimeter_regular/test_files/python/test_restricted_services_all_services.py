from sys import path, stderr

try:
    path.insert(1, '../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, stderr)

"""
    Tests whether using the enum `ALL-SERVICES` will default restricted services to have all listed services
"""

expected_data = {
    "accessapproval.googleapis.com": "accessapproval.googleapis.com",
    "adsdatahub.googleapis.com": "adsdatahub.googleapis.com",
    "aiplatform.googleapis.com": "aiplatform.googleapis.com",
    "apigeeconnect.googleapis.com": "apigeeconnect.googleapis.com",
    "apigee.googleapis.com": "apigee.googleapis.com",
    "artifactregistry.googleapis.com": "artifactregistry.googleapis.com",
    "assuredworkloads.googleapis.com": "assuredworkloads.googleapis.com",
    "automl.googleapis.com": "automl.googleapis.com",
    "bigquerydatatransfer.googleapis.com": "bigquerydatatransfer.googleapis.com",
    "bigquery.googleapis.com": "bigquery.googleapis.com",
    "bigtable.googleapis.com": "bigtable.googleapis.com",
    "binaryauthorization.googleapis.com": "binaryauthorization.googleapis.com",
    "cloudasset.googleapis.com": "cloudasset.googleapis.com",
    "cloudbuild.googleapis.com": "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com": "cloudfunctions.googleapis.com",
    "cloudkms.googleapis.com": "cloudkms.googleapis.com",
    "cloudprofiler.googleapis.com": "cloudprofiler.googleapis.com",
    "cloudresourcemanager.googleapis.com": "cloudresourcemanager.googleapis.com",
    "cloudsearch.googleapis.com": "cloudsearch.googleapis.com",
    "cloudtrace.googleapis.com": "cloudtrace.googleapis.com",
    "composer.googleapis.com": "composer.googleapis.com",
    "compute.googleapis.com": "compute.googleapis.com",
    "connectgateway.googleapis.com": "connectgateway.googleapis.com",
    "containeranalysis.googleapis.com": "containeranalysis.googleapis.com",
    "container.googleapis.com": "container.googleapis.com",
    "containerregistry.googleapis.com": "containerregistry.googleapis.com",
    "containerthreatdetection.googleapis.com": "containerthreatdetection.googleapis.com",
    "datacatalog.googleapis.com": "datacatalog.googleapis.com",
    "dataflow.googleapis.com": "dataflow.googleapis.com",
    "datafusion.googleapis.com": "datafusion.googleapis.com",
    "dataproc.googleapis.com": "dataproc.googleapis.com",
    "dialogflow.googleapis.com": "dialogflow.googleapis.com",
    "dlp.googleapis.com": "dlp.googleapis.com",
    "dns.googleapis.com": "dns.googleapis.com",
    "documentai.googleapis.com": "documentai.googleapis.com",
    "file.googleapis.com": "file.googleapis.com",
    "gameservices.googleapis.com": "gameservices.googleapis.com",
    "gkeconnect.googleapis.com": "gkeconnect.googleapis.com",
    "gkehub.googleapis.com": "gkehub.googleapis.com",
    "healthcare.googleapis.com": "healthcare.googleapis.com",
    "iam.googleapis.com": "iam.googleapis.com",
    "iaptunnel.googleapis.com": "iaptunnel.googleapis.com",
    "language.googleapis.com": "language.googleapis.com",
    "lifesciences.googleapis.com": "lifesciences.googleapis.com",
    "logging.googleapis.com": "logging.googleapis.com",
    "managedidentities.googleapis.com": "managedidentities.googleapis.com",
    "memcache.googleapis.com": "memcache.googleapis.com",
    "meshca.googleapis.com": "meshca.googleapis.com",
    "metastore.googleapis.com": "metastore.googleapis.com",
    "ml.googleapis.com": "ml.googleapis.com",
    "monitoring.googleapis.com": "monitoring.googleapis.com",
    "networkconnectivity.googleapis.com": "networkconnectivity.googleapis.com",
    "networkmanagement.googleapis.com": "networkmanagement.googleapis.com",
    "networksecurity.googleapis.com": "networksecurity.googleapis.com",
    "networkservices.googleapis.com": "networkservices.googleapis.com",
    "notebooks.googleapis.com": "notebooks.googleapis.com",
    "opsconfigmonitoring.googleapis.com": "opsconfigmonitoring.googleapis.com",
    "osconfig.googleapis.com": "osconfig.googleapis.com",
    "oslogin.googleapis.com": "oslogin.googleapis.com",
    "privateca.googleapis.com": "privateca.googleapis.com",
    "pubsub.googleapis.com": "pubsub.googleapis.com",
    "pubsublite.googleapis.com": "pubsublite.googleapis.com",
    "recaptchaenterprise.googleapis.com": "recaptchaenterprise.googleapis.com",
    "recommender.googleapis.com": "recommender.googleapis.com",
    "redis.googleapis.com": "redis.googleapis.com",
    "run.googleapis.com": "run.googleapis.com",
    "secretmanager.googleapis.com": "secretmanager.googleapis.com",
    "servicecontrol.googleapis.com": "servicecontrol.googleapis.com",
    "servicedirectory.googleapis.com": "servicedirectory.googleapis.com",
    "spanner.googleapis.com": "spanner.googleapis.com",
    "speech.googleapis.com": "speech.googleapis.com",
    "sqladmin.googleapis.com": "sqladmin.googleapis.com",
    "storage.googleapis.com": "storage.googleapis.com",
    "storagetransfer.googleapis.com": "storagetransfer.googleapis.com",
    "sts.googleapis.com": "sts.googleapis.com",
    "texttospeech.googleapis.com": "texttospeech.googleapis.com",
    "tpu.googleapis.com": "tpu.googleapis.com",
    "trafficdirector.googleapis.com": "trafficdirector.googleapis.com",
    "transcoder.googleapis.com": "transcoder.googleapis.com",
    "translate.googleapis.com": "translate.googleapis.com",
    "videointelligence.googleapis.com": "videointelligence.googleapis.com",
    "vision.googleapis.com": "vision.googleapis.com",
    "vpcaccess.googleapis.com": "vpcaccess.googleapis.com"
}



if __name__ == '__main__':
    python_validator(expected_data)
