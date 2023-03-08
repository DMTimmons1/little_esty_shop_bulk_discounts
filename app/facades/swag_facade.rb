require './app/poros/holiday'
require './app/services/swag_service'

class SwagFacade
  def holiday
    service.holidays.map do |data|
      Holiday.new(data)
    end
  end

  def service
    SwagService.new
  end
end