output "file_path" {
  description = "Path to the generated file."
  value       = local_file.example.filename
}

output "file_content" {
  description = "Content written to the generated file."
  value       = local_file.example.content
}

output "file_name" {
  description = "Base name of the generated file."
  value       = basename(local_file.example.filename)
}