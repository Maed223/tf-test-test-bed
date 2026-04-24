terraform {
  required_version = ">= 1.6.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

locals {
  managed_file_path = "${path.module}/${var.name}-tapas.txt"
  orphan_file_path  = "${path.module}/${var.name}-orphan-tapas.txt"

  managed_file_path2 = "${path.module}/${var.name}-krill.txt"
  orphan_file_path2  = "${path.module}/${var.name}-orphan-krill.txt"
}

resource "random_pet" "suffix" {
  length = 1
}

resource "local_file" "example" {
  filename = local.managed_file_path
  content  = var.content
}

resource "terraform_data" "orphaned_test_artifact" {
  input = {
    content = var.content
    path    = local.orphan_file_path
  }

  provisioner "local-exec" {
    command = "printf '%s' \"$ORPHAN_CONTENT\" > \"$ORPHAN_PATH\""

    environment = {
      ORPHAN_CONTENT = self.input.content
      ORPHAN_PATH    = self.input.path
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "echo 'intentional terraform test cleanup failure' >&2; exit 1"
  }
}

resource "local_file" "example2" {
  filename = local.managed_file_path2
  content  = var.content
}

/**

resource "terraform_data" "orphaned_test_artifact2" {
  input = {
    content = var.content
    path    = local.orphan_file_path2
  }

  provisioner "local-exec" {
    command = "printf '%s' \"$ORPHAN_CONTENT\" > \"$ORPHAN_PATH\""

    environment = {
      ORPHAN_CONTENT = self.input.content
      ORPHAN_PATH    = self.input.path
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "echo 'intentional terraform test cleanup failure' >&2; exit 1"
  }
}
*/