class TargetArea < ActiveRecord::Base
  self.table_name = 'ministry_targetarea'
  self.inheritance_column = 'asdf'
  self.primary_key = 'targetAreaID'

  def add
    {
      type: 'add',
      id: global_registry_id,
      fields: fields
    }
  end

  def delete
    {
      type: 'delete',
      id: global_registry_id
    }
  end

  def fields
    {
      name: name,
      alt_names: [abbrv.to_s.split(','), altName].flatten.select {|s| s.present?}.compact,
      city: city,
      zip: zip.to_s,
      state: state,
      latlon: [latitude, longitude].join(','),
      ministries: ministries,
      type: type
    }
  end

  def ministries
    sql = "select distinct(m.name) from `ministry_targetarea` t
          join ministry_activity a on a.`fk_targetAreaID` = t.`targetAreaID`
          join `ministry_locallevel` l on l.`teamID` = a.`fk_teamID`
          join ministry_strategy m on l.lane = m.abreviation
          where status <> 'IN'
          and t.isSecure = 'F'
          and t.targetAreaID = #{id}"
    ActiveRecord::Base.connection.select_values(sql)
  end
end