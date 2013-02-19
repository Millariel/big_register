module BIGRegister
  class Client

    SPECIALISM = {"2" => "Allergologie", "3" => "Anesthesiologie","4" => "Algemene gezondheidszorg",
                  "5" => "Medische milieukunde", "6" => "Tuberculosebestrijding", "7" => "Arbeid en gezondheid",
                  "8" => "Arbeid en gezondheid - bedrijfsgeneeskunde", "10" => "Cardiologie", "11" => "Cardio-thoracale chirurgie",
                  "12" => "Dermatologie en venerologie", "13" => "Leer van maag-darm-leverziekten", "14" => "Heelkunde",
                  "15" => "Huisartsgeneeskunde", "16" => "Inwendige geneeskunde", "17" => "Jeugdgezondheidszorg", "18" => "Keel- neus- oorheelkunde",
                  "19" => "Kindergeneeskunde", "20" => "Klinische chemie", "21" => "Klinische genetica", "22" => "Klinische geriatrie",
                  "23" => "Longziekten en tuberculose", "24" => "Medische microbiologie", "25" => "Neurochirurgie",
                  "26" => "Neurologie", "30" => "Nucleaire geneeskunde", "31" => "Oogheelkunde", "32" => "Orthopedie",
                  "33" => "Pathologie", "34" => "Plastische chirurgie", "35" => "Psychiatrie", "39" => "Radiologie",
                  "40" => "Radiotherapie", "41" => "Reumatologie", "42" => "Revalidatiegeneeskunde", "43" => "Maatschappij en gezondheid",
                  "44" => "Sportgeneeskunde", "45" => "Urologie", "46" => "Obstetrie en gynaecologie", "47" => "Verpleeghuisgeneeskunde",
                  "48" => "Arbeid en gezondheid - verzekeringsgeneeskunde", "50" => "Zenuw- en zielsziekten", "53" => "Dento-maxillaire orthopaedie",
                  "54" => "Mondziekten en kaakchirurgie", "55" => "Maatschappij en gezondheid", "56" => "Medische zorg voor verstandelijke gehandicapten",
                  "60" => "Ziekenhuisfarmacie", "61" => "Klinische psychologie", "62" => "Interne geneeskunde-allergologie"
                  }

    def initialize
      wsdl = "http://webservices-acc.cibg.nl/Ribiz/OpenbaarV2.asmx?wsdl"
      @client = Savon.client(wsdl: wsdl, log_level: :warn)
    end

    def list_hcp(initials, name, gender, specialism)
      message = create_message(initials, name, gender, specialism)
      response = @client.call(:list_hcp_approx3, message: message)
      result = format_response(response)
      result = [result] if result.class == Hash
      result
    end

    def find_by_big_number(big_number)
      message = {
        "WebSite" => "Ribiz",
        "RegistrationNumber" => big_number
      }
      response = @client.call(:list_hcp_approx3, message: message)
      format_response(response)
    end

    private

    def create_message(initials, name, gender, specialism)
      message = {
        "WebSite" => "Ribiz",
        "ProfessionalGroup" => "01",
      }
      message["Initials"] = initials unless initials.blank?
      message["Name"] = name unless name.blank?
      message["Gender"] = gender unless gender.blank?
      message["TypeOfSpecialism"] = specialism.to_i unless specialism.blank?
      message
    end

    def format_response(response)
      result = response.body[:list_hcp_approx3_result][:list_hcp_approx] ||= []
      result = result[:list_hcp_approx3] unless result.empty?
      result
    end

  end
end
