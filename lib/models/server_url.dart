class ServerUrl {
  int? id;
  String? urlApiServer;
  String? urlApiPort;
  String? urlSocketServer;
  String? urlSocketPort;
  String? nameServer;
  int? mainServer;
  int? statusServer;

  ServerUrl(
      {this.id,
      this.urlApiServer,
      this.urlApiPort,
      this.urlSocketServer,
      this.urlSocketPort,
      this.nameServer,
      this.mainServer,
      this.statusServer});

  ServerUrl.fromJson(Map<String, dynamic> data) {
    id = (data['_id'] ?? data['id']);
    urlApiServer = data['url_api_server'];
    urlApiPort = data['url_api_port'];
    urlSocketServer = data['url_socket_server'];
    urlSocketPort = data['url_socket_port'];
    nameServer = data['name_server'];
    mainServer = data['main_server'];
    statusServer = data['status_server'];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "urlApiServer": urlApiServer,
        "urlApiPort": urlApiPort,
        "urlSocketServer": urlSocketServer,
        "urlSocketPort": urlSocketPort,
        "nameServer": nameServer,
        "mainServer": mainServer,
        "statusServer": statusServer
      };
}
