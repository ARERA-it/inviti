require 'faraday'


# classe preposta al recupero di dati relativi alla Gestione del gestione
# al fine di mantenere sincronizzato la tabella User con, appunto, il database del personale
class PersonnelManagement

  # Fornisce la lista di tutti gli utenti
  def self.all
    uri = built_uri('getAllId')
    response = Faraday.get uri
    # puts response.body
    array = JSON.parse(response.body)
  end


  # Param shold be a username like 'mpolito' or an id like 177
  # Fornisce info dettagliate relative ad un singolo utente
  # E' possibile passare l'id (numero intero) oppure lo username
  # ad es. 'dmargagliotta'
  def self.find(param)
    if param.is_a? String
      uri = built_uri('getAttributes', param)
    else
      uri = built_uri('getAttributesById', param)
    end
    response = Faraday.get uri
    hash = JSON.parse(response.body)
    raise hash['Error'] if hash.has_key?("Error")
    hash
  end

  private
  def self.built_uri(*arguments)
    a = [ENV['gestione_personale_host']]
    a << 'gestione-personale'
    a << 'api'
    a << 'v1'
    a += arguments
    a.join('/') + "?" + "X-Authorization=#{ENV['gestione_personale_token']}"
  end
end
