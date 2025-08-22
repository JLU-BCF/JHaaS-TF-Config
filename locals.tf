locals {
  k8s_namespace = "jhaas-${var.name}"
  jh_hostname   = "${var.name}.${var.domain}"
  shared_volumes = jsondecode(var.shared_volumes_conf)
}

# {
#   name: {
#     mointpoint: "/srv/data",
#     readonly: true,
#     size: "20Gi"
#   }
# }

locals {
  shared_extra_volumes = [for name, props in local.shared_volumes :
    {
      name = name
      persistentVolumeClaim = {
        claimName = name
      }
    }
  ]

  shared_extra_volume_mounts = [for name, props in local.shared_volumes :
    {
      mountPath = props.mountpoint
      name = name
      readOnly = props.readonly
    }
  ]
}
