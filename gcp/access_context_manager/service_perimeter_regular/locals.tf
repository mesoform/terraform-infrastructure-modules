locals {
  ingress_file      = try(fileexists(var.ingress_file_path), fileexists("./ingress_policies.yml")) ? file(var.ingress_file_path) : null
  ingress_policies  = try(yamldecode(local.ingress_file), [])

  egress_file      = try(fileexists(var.egress_file_path), fileexists("./egress_policies.yml")) ? file(var.egress_file_path) : null
  egress_policies  = try(yamldecode(local.egress_file), [])

  requested_restricted_services = var.restricted_services == null ? ["ALL-SERVICES"] : var.restricted_services
  restricted_services = contains(local.requested_restricted_services, "ALL-SERVICES") ? local.vpc_sc_supported_services : var.restricted_services
  enable_vpc_accessible_services = contains(local.vpc_accessible_services, "ALL-SERVICES") ? false : true
  vpc_accessible_services = var.vpc_accessible_services == null ? ["RESTRICTED-SERVICES"] : local.enable_vpc_accessible_services == false ? [] : var.vpc_accessible_services  vpc_enable_restriction = contains(local.vpc_accessible_services, "ALL-SERVICES" ) ? false : true
  vpc_sc_supported_services = [
                                "accessapproval.googleapis.com",
                                "adsdatahub.googleapis.com",
                                "aiplatform.googleapis.com",
                                "apigeeconnect.googleapis.com",
                                "apigee.googleapis.com",
                                "artifactregistry.googleapis.com",
                                "assuredworkloads.googleapis.com",
                                "automl.googleapis.com",
                                "bigquerydatatransfer.googleapis.com",
                                "bigquery.googleapis.com",
                                "bigtable.googleapis.com",
                                "binaryauthorization.googleapis.com",
                                "cloudasset.googleapis.com",
                                "cloudbuild.googleapis.com",
                                "cloudfunctions.googleapis.com",
                                "cloudkms.googleapis.com",
                                "cloudprofiler.googleapis.com",
                                "cloudresourcemanager.googleapis.com",
                                "cloudsearch.googleapis.com",
                                "cloudtrace.googleapis.com",
                                "composer.googleapis.com",
                                "compute.googleapis.com",
                                "connectgateway.googleapis.com",
                                "containeranalysis.googleapis.com",
                                "container.googleapis.com",
                                "containerregistry.googleapis.com",
                                "containerthreatdetection.googleapis.com",
                                "datacatalog.googleapis.com",
                                "dataflow.googleapis.com",
                                "datafusion.googleapis.com",
                                "dataproc.googleapis.com",
                                "dialogflow.googleapis.com",
                                "dlp.googleapis.com",
                                "dns.googleapis.com",
                                "documentai.googleapis.com",
                                "file.googleapis.com",
                                "gameservices.googleapis.com",
                                "gkeconnect.googleapis.com",
                                "gkehub.googleapis.com",
                                "healthcare.googleapis.com",
                                "iam.googleapis.com",
                                "iaptunnel.googleapis.com",
                                "language.googleapis.com",
                                "lifesciences.googleapis.com",
                                "logging.googleapis.com",
                                "managedidentities.googleapis.com",
                                "memcache.googleapis.com",
                                "meshca.googleapis.com",
                                "metastore.googleapis.com",
                                "ml.googleapis.com",
                                "monitoring.googleapis.com",
                                "networkconnectivity.googleapis.com",
                                "networkmanagement.googleapis.com",
                                "networksecurity.googleapis.com",
                                "networkservices.googleapis.com",
                                "notebooks.googleapis.com",
                                "opsconfigmonitoring.googleapis.com",
                                "osconfig.googleapis.com",
                                "oslogin.googleapis.com",
                                "privateca.googleapis.com",
                                "pubsub.googleapis.com",
                                "pubsublite.googleapis.com",
                                "recaptchaenterprise.googleapis.com",
                                "recommender.googleapis.com",
                                "redis.googleapis.com",
                                "run.googleapis.com",
                                "secretmanager.googleapis.com",
                                "servicecontrol.googleapis.com",
                                "servicedirectory.googleapis.com",
                                "spanner.googleapis.com",
                                "speech.googleapis.com",
                                "sqladmin.googleapis.com",
                                "storage.googleapis.com",
                                "storagetransfer.googleapis.com",
                                "sts.googleapis.com",
                                "texttospeech.googleapis.com",
                                "tpu.googleapis.com",
                                "trafficdirector.googleapis.com",
                                "transcoder.googleapis.com",
                                "translate.googleapis.com",
                                "videointelligence.googleapis.com",
                                "vision.googleapis.com",
                                "vpcaccess.googleapis.com"
                              ]
  //noinspection HILUnresolvedReference
  resources = [
    for project in data.google_project.self:
          "projects/${project.number}"
  ]
}
