resource "kubernetes_persistent_volume" "self" {
  for_each = local.k8s_persistent_volume
  metadata {
    name        = lookup(each.value.persistent_volume.metadata, "name", null )
    labels      = lookup(each.value.persistent_volume.metadata, "labels", null )
    annotations = lookup(each.value.persistent_volume.metadata, "annotations", null)
  }
  spec {
    access_modes                     = lookup(each.value.persistent_volume.spec, "access_modes", {} )
    capacity                         = lookup(each.value.persistent_volume.spec, "capacity", {} )
    persistent_volume_reclaim_policy = lookup(each.value.persistent_volume.spec, "persistent_volume_reclaim_policy", null )
    storage_class_name               = lookup(each.value.persistent_volume.spec, "storage_class_name", "standard" )
    mount_options                    = lookup(each.value.persistent_volume.spec, "mount_options", null )
    persistent_volume_source {
      dynamic aws_elastic_block_store {
        for_each = lookup(each.value.persistent_volume.spec.persistent_volume_source, "aws_elastic_block_store", null ) == null ? {} : {
          aws_elastic_block_store : each.value.persistent_volume.spec.persistent_volume_source.aws_elastic_block_store
        }
        content {
          volume_id = aws_elastic_block_store.value.volume_id
          fs_type   = lookup(aws_elastic_block_store.value, "fs_type", null )
          partition = lookup(aws_elastic_block_store.value, "partition", null )
          read_only = lookup(aws_elastic_block_store.value, "read_only", null )
        }
      }
      dynamic azure_disk {
        for_each = lookup(each.value.persistent_volume.spec.persistent_volume_source, "azure_disk", null ) == null ? {} : {
          azure_disk : each.value.persistent_volume.spec.persistent_volume_source.azure_disk
        }
        content {
          caching_mode  = azure_disk.value.caching_mode
          data_disk_uri = azure_disk.value.data_disk_uri
          disk_name     = azure_disk.value.disk_name
          fs_type       = lookup(azure_disk.value, "fs_type", null )
          read_only     = lookup(azure_disk.value, "read_oly", null )
        }
      }
      dynamic azure_file {
        for_each = lookup(each.value.persistent_volume.spec.persistent_volume_source, "azure_file", null ) == null ? {} : {
          azure_file : each.value.persistent_volume.spec.persistent_volume_source.azure_file
        }
        content {
          secret_name = azure_file.value.secret_name
          share_name  = azure_file.value.share_name
          read_only   = lookup(azure_file.value, "read_only", null)
        }
      }
      dynamic ceph_fs {
        for_each = lookup(each.value.persistent_volume.spec.persistent_volume_source, "ceph_fs", null ) == null ? {} : {
          ceph_fs : each.value.persistent_volume.spec.persistent_volume_source.ceph_fs
        }
        content{
          monitors    = lookup(ceph_fs.value, "monitors", [])
          path        = lookup(ceph_fs.value, "path", null)
          read_only   = lookup(ceph_fs.value, "read_only", null)
          secret_file = lookup(ceph_fs.value, "secret_file", null)
          user        = lookup(ceph_fs.value, "user", null)
          dynamic secret_ref {
            for_each = lookup(ceph_fs.value, "secret_ref", null) == null ? {} : {secret_ref: ceph_fs.value.secret_ref}
            content {
              name      = lookup(secret_ref.value, "name", null)
              namespace = lookup(secret_ref.value, "namespace", null )
            }
          }
        }
      }
      dynamic cinder {
        for_each = lookup(each.value.persistent_volume.spec.persistent_volume_source, "cinder", null ) == null ? {} : {
          cinder : each.value.persistent_volume.spec.persistent_volume_source.cinder
        }
        content {
          volume_id = cinder.value.volume_id
          fs_type   = lookup(cinder.value, "fs_type", null)
          read_only = lookup(cinder.value, "read_only", null)
        }
      }

      dynamic fc {
        for_each = lookup(each.value.persistent_volume.spec.persistent_volume_source, "fc", null ) == null ? {} : {
          fc : each.value.persistent_volume.spec.persistent_volume_source.fc
        }
        content {
          lun          = lookup(fc.value, "lun", 0)
          target_ww_ns = lookup(fc.value, "target_ww_ns", [])
          fs_type      = lookup(fc.value, "fs_type", null)
          read_only    = lookup(fc.value, "read_only", null)
        }
      }
      dynamic flex_volume {
        for_each = lookup(each.value.persistent_volume.spec.persistent_volume_source, "azure_disk", null ) == null ? {} : {
          azure_disk : each.value.persistent_volume.spec.persistent_volume_source.azure_disk
        }
        content {
          driver    = flex_volume.value.driver
          fs_type   = lookup(flex_volume.value, "fs_type", null)
          read_only = lookup(flex_volume.value, "read_only", null)
          options   = lookup(flex_volume.value, "options", null)
          dynamic secret_ref {
            for_each = lookup(flex_volume.value, "secret_ref", null) == null ? {} : {secret_ref: flex_volume.value.secret_ref}
            content {
              name      = lookup(secret_ref.value, "name", null)
              namespace = lookup(secret_ref.value, "namespace", null )
            }
          }
        }
      }
      dynamic flocker {
        for_each = lookup(each.value.persistent_volume.spec.persistent_volume_source, "flocker", null ) == null ? {} : {
          flocker : each.value.persistent_volume.spec.persistent_volume_source.flocker
        }
        content {
          dataset_name = lookup(flocker.value, "dataset_name", null)
          dataset_uuid = lookup(flocker.value, "dataset_uuid", null)
        }
      }
      dynamic gce_persistent_disk {
        for_each = lookup(each.value.persistent_volume.spec.persistent_volume_source, "gce_persistent_disk", null ) == null ? {} : {
          gce_persistent_disk : each.value.persistent_volume.spec.persistent_volume_source.gce_persistent_disk
        }
        content {
          pd_name   = gce_persistent_disk.value.pd_name
          fs_type   = lookup(gce_persistent_disk.value, "fs_type", null)
          read_only = lookup(gce_persistent_disk.value, "read_only", null)
        }
      }
      dynamic glusterfs {
        for_each = lookup(each.value.persistent_volume.spec.persistent_volume_source, "glusterfs", null ) == null ? {} : {
          glusterfs : each.value.persistent_volume.spec.persistent_volume_source.glusterfs
        }
        content {
          endpoints_name = glusterfs.value.endpoints_name
          path           = glusterfs.value.path
          read_only      = lookup(glusterfs.value, "read_only", null)
        }
      }
      dynamic host_path {
        for_each = lookup(each.value.persistent_volume.spec.persistent_volume_source, "host_path", null ) == null ? {} : {
          host_path : each.value.persistent_volume.spec.persistent_volume_source.host_path
        }
        content {
          path = lookup(host_path.value, "path", null)
          type = lookup(host_path.value, "type", null)
        }
      }
      dynamic iscsi {
        for_each = lookup(each.value.persistent_volume.spec.persistent_volume_source, "iscsi", null ) == null ? {} : {
          iscsi : each.value.persistent_volume.spec.persistent_volume_source.iscsi
        }
        content {
          iqn             = iscsi.value.iqn
          target_portal   = lookup(iscsi.value, "target_portal", null)
          fs_type         = lookup(iscsi.value, "fs_type", null)
          read_only       = lookup(iscsi.value, "read_only", null)
          lun             = lookup(iscsi.value, "lun", null )
          iscsi_interface = lookup(iscsi.value, "iscsi_interaface", null )
        }
      }
      dynamic local {
        for_each = lookup(each.value.persistent_volume.spec.persistent_volume_source, "local", null ) == null ? {} : {
          local : each.value.persistent_volume.spec.persistent_volume_source.local
        }
        iterator = local_path
        content {
          path = lookup(local_path.value, "path", null)
        }
      }
      dynamic nfs {
        for_each = lookup(each.value.persistent_volume.spec.persistent_volume_source, "nfs", null ) == null ? {} : {
          nfs : each.value.persistent_volume.spec.persistent_volume_source.nfs
        }
        content {
          path      = lookup(nfs.value, "path", null )
          server    = lookup(nfs.value, "server", null)
          read_only = lookup(nfs.value, "read_only", null)
        }
      }
      dynamic photon_persistent_disk {
        for_each = lookup(each.value.persistent_volume.spec.persistent_volume_source, "photon_persistent_disk", null ) == null ? {} : {
          photon_persistent_disk : each.value.persistent_volume.spec.persistent_volume_source.photon_persistent_disk
        }
        content {
          pd_id   = photon_persistent_disk.value.pd_id
          fs_type = lookup(gce_persistent_disk.value, "fs_type", null)
        }
      }
      dynamic quobyte {
        for_each = lookup(each.value.persistent_volume.spec.persistent_volume_source, "quobyte", null ) == null ? {} : {
          quobyte : each.value.persistent_volume.spec.persistent_volume_source.quobyte
        }
        content {
          registry = quobyte.value.registry
          volume   = quobyte.value.volume
          group    = lookup(quobyte.value, "group", null )
        }
      }
      dynamic rbd {
        for_each = lookup(each.value.persistent_volume.spec.persistent_volume_source, "rbd", null ) == null ? {} : {
          rbd : each.value.persistent_volume.spec.persistent_volume_source.rbd
        }
        content {
          ceph_monitors = rbd.value.ceph_monitors
          rbd_image     = rbd.value.rbd_image
          fs_type       = lookup(rbd.value, "fs_type", null)
          keyring       = lookup(rbd.value, "keyring", null)
          rados_user    = lookup(rbd.value, "rados_user", null)
          rbd_pool      = lookup(rbd.value, "rbd_pool", null)
          read_only     = lookup(rbd.value, "read_only", null)
          dynamic secret_ref {
            for_each = lookup(rbd.value, "secret_ref", null) == null ? {} : {secret_ref: rbd.value.secret_ref}
            content {
              name      = lookup(secret_ref.value, "name", null)
              namespace = lookup(secret_ref.value, "namespace", null )
            }
          }

        }
      }
      dynamic vsphere_volume {
        for_each = lookup(each.value.persistent_volume.spec.persistent_volume_source, "vsphere_volume", null ) == null ? {} : {
          vsphere_volume : each.value.persistent_volume.spec.persistent_volume_source.vsphere_volume
        }
        content{
          volume_path = vsphere_volume.value.volume_path
          fs_type     = lookup(vsphere_volume.value, "fs_type", null )
        }
      }
    }

    dynamic node_affinity {
      for_each = lookup(each.value.persistent_volume.spec, "node_affinity", null) == null ? {} : {node_affinity: each.value.persistent_volume.spec.node_affinity}
      content {
        dynamic required {
          for_each = lookup(node_affinity.value, "required", null) == null ? {} : {required: node_affinity.value.required}
          content {
            node_selector_term {
              dynamic match_fields {
                for_each = lookup(required.value.node_selector_term, "match_fields", null) == null ? {}: {
                  for match_fields in required.value.node_selector_term.match_fields:
                    match_fields.key => match_fields
                }
                content{
                  key      = match_fields.value.key
                  operator = match_fields.value.operator
                  values   = lookup(match_fields.value, "values", null)
                }
              }
              dynamic match_expressions {
                for_each = lookup(required.value.node_selector_term, "match_expressions", null) == null ? {}: {
                  for match_expression in required.value.node_selector_term.match_expressions:
                    match_expression.key => match_expression
                }
                content{
                  key      = match_expressions.value.key
                  operator = match_expressions.value.operator
                  values   = lookup(match_expressions.value, "values", null)
                }
              }
            }
          }
        }
      }
    }
  }
}