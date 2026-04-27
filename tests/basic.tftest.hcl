variables {
  name    = "fixture"
  content = "hello from terraform test"
}

run "plan_uses_test_inputs" {
  command = plan

  assert {
    condition     = output.file_content == "hello from terraform test"
    error_message = "The planned output should reflect the test content input."
  }
}

run "apply_writes_expected_file" {
  command = apply

  assert {
    condition     = file(output.file_path) == "hello from terraform test"
    error_message = "The applied file content should match the requested content."
  }

  assert {
    condition     = startswith(output.file_name, "fixture-")
    error_message = "The applied file name should start with the provided name prefix."
  }

  assert {
    condition     = output.file_name == basename(output.file_path)
    error_message = "The file name output should match the basename of the file path."
  }
}