namespace :cloudsearch do
  task add: :environment do
    batch = []
    TargetArea.find_each do |t|
      batch << t.add if t.ministries.present? && t.latitude.present? && t.longitude.present?
    end

    domain = Aws::CloudSearchDomain::Client.new(endpoint: Rails.application.secrets.doc_endpoint)
    resp = domain.upload_documents(documents: batch.to_json, content_type: 'application/json')
  end

  task delete: :environment do
    batch = []
    TargetArea.find_each do |t|
      batch << t.delete
    end

    domain = Aws::CloudSearchDomain::Client.new(endpoint: Rails.application.secrets.doc_endpoint)
    resp = domain.upload_documents(documents: batch.to_json, content_type: 'application/json')
  end
end

