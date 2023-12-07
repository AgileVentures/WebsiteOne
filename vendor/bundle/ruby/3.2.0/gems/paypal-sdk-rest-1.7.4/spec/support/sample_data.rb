module SampleData
  def samples
    @@samples ||= YAML.load(File.read(File.expand_path("../../config/sample_data.yml", __FILE__)))
  end
end
