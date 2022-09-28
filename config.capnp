using Workerd = import "/workerd/workerd.capnp";

const config :Workerd.Config = (
  services = [
    (name = "main", worker = .mainWorker),
    (name = "test", worker = .testWorker),
  ],

  sockets = [
    # Serve HTTP on port 8080.
    ( name = "http",
      address = "*:8080",
      http = (),
      service = "main"
    ),
  ]
);

const mainWorker :Workerd.Worker = (
  compatibilityDate = "2022-09-16",

  modules = [
    ( name = "worker.mjs", esModule = embed "worker.mjs" ),
  ],
  bindings = [
    ( name = "TEST", service = ( name = "test" ) ),
  ],
);

const testWorker :Workerd.Worker = (
  compatibilityDate = "2022-09-16",

  modules = [
    ( name = "test.mjs", esModule = embed "test.mjs" ),
  ],
);
