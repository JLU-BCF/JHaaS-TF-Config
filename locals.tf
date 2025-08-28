locals {
  k8s_namespace  = "jhaas-${var.name}"
  jh_hostname    = "${var.name}.${var.domain}"
  fb_name        = "fb-${var.name}"
  shared_volumes = jsondecode(var.shared_volumes_conf)
}

locals {
  fb_hostname = "${local.fb_name}.${var.domain}"
}

# {
#   name: {
#     mointpoint: "/srv/data",
#     readonly: true,
#     size: "20Gi"
#   }
# }

locals {
  jh_shared_extra_volumes = [for name, props in local.shared_volumes :
    {
      name = name
      persistentVolumeClaim = {
        claimName = name
      }
    }
  ]

  jh_shared_extra_volume_mounts = [for name, props in local.shared_volumes :
    {
      mountPath = props.mountpoint
      name      = name
      readOnly  = props.readonly
    }
  ]

  fb_shared_extra_volumes = [for name, props in local.shared_volumes :
    {
      name = name
      persistentVolumeClaim = {
        claimName = name
      }
    }
  ]

  fb_shared_extra_volume_mounts = [for name, props in local.shared_volumes :
    {
      mountPath = props.mountpoint
      name      = name
      # in contrast to JH here volumes must always be readwrite
      readOnly = false
    }
  ]

  fb_shared_volume_sources = [for name, props in local.shared_volumes :
    {
      path = props.mountpoint
      name = name
      config = {
        disableIndexing : true
        defaultEnabled : true
      }
    }
  ]
}
