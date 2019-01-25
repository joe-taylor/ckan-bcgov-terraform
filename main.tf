module "dev"{
  source = "dev"

  gitUsername = "${var.gitUsername}"
  preferFork = "${var.preferFork}"

  installPath = "${var.installPath}"

  ckanRepo = "${var.ckanRepo}"
  ckanBranch = "${var.ckanBranch}"

  ckanExtBcGov = "${var.ckanExtBcGov}"
  ckanExtBcGovBranch = "${var.ckanExtBcGovBranch}"
  ckanExtBcGovCli = "${var.ckanExtBcGovCli}"
  ckanExtBcGovCliBranch = "${var.ckanExtBcGovCliBranch}"
  ckanExtOpenApiViewer = "${var.ckanExtOpenApiViewer}"
  ckanExtOpenApiViewerBranch = "${var.ckanExtOpenApiViewerBranch}"

  ckanExtRssSource = "${var.ckanExtRssSource}"
  ckanExtRss = "${var.ckanExtRss}"
  ckanExtRssBranch = "${var.ckanExtRssBranch}"

  ckanExtDisqus = "${var.ckanExtDisqus}"
  ckanExtDisqusBranch = "${var.ckanExtDisqusBranch}"
  ckanExtGaReport = "${var.ckanExtGaReport}"
  ckanExtGaReportBranch = "${var.ckanExtGaReportBranch}"
  ckanExtGeoview = "${var.ckanExtGeoview}"
  ckanExtGeoviewBranch = "${var.ckanExtGeoviewBranch}"
  ckanExtGoogleAnalytics = "${var.ckanExtGoogleAnalytics}"
  ckanExtGoogleAnalyticsBranch = "${var.ckanExtGoogleAnalyticsBranch}"
  ckanExtHierarchy = "${var.ckanExtHierarchy}"
  ckanExtHierarchyBranch = "${var.ckanExtHierarchyBranch}"

  ckanExtDatapusher = "${var.ckanExtDatapusher}"
  ckanExtDatapusherBranch = "${var.ckanExtDatapusherBranch}"

  solrRepo = "${var.solrRepo}"
  solrTag = "${var.solrTag}"

  postgresRepo = "${var.postgresRepo}"
  postgresTag = "${var.postgresTag}"

  redisRepo = "${var.redisRepo}"
  redisTag = "${var.redisTag}"

  solrCore = "${var.solrCore}"
  solrPort = "${var.solrPort}"

  postgresDb = "${var.postgresDb}"
  postgresUser = "${var.postgresUser}"
  postgresPass = "${var.postgresPass}"
  postgresPort = "${var.postgresPort}"

  redisPort = "${var.redisPort}"

  ckanPlugins = "${var.ckanPlugins}"
  ckanVersion = "${var.ckanVersion}"

  gaID="${var.gaID}"
  gaAccount="${var.gaAccount}"
  gaUser="${var.gaUser}"
}