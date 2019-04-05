module Helpers

  def last_response_body
    OpenStruct.new(JSON.parse(last_response.body))
  end

  def to_json(hash)
    JSON[hash.to_json]
  end

  def create_query(string)
    length = string.length
    end_number = length > 3 ? Random.rand(3..(length-1)) : length - 1
    string.downcase[0...end_number]
  end

  def get_ids(array_of_hash, id_key)
    array_of_hash.map { |result_hash| result_hash[id_key] if result_hash.key?(id_key) }
  end

end
