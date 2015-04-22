class Location
  attr_accessor :id, :name, :alt_names, :city, :state, :zip, :latlon, :ministries, :type

  def initialize(hit)
    self.id = hit.id
    [:name, :alt_names, :city, :state, :zip, :latlon, :ministries, :type].each do |k|
      v = hit.fields[k.to_s]
      self.send("#{k}=".to_sym, v ? v : [])
    end
  end

  def to_hash
    latitude, longitude = (latlon || []).first.to_s.split(',')
    {
      id: id,
      name: name.first,
      alt_names: alt_names,
      city: city.first,
      state: state.first,
      zip: zip.first,
      latitude: latitude,
      longitude: longitude,
      ministries: ministries,
      type: type.first
    }
  end

  def to_json
    to_hash.to_json
  end
end