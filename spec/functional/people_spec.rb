RSpec.describe 'People Controller Test' do
  describe 'parse dollar and percent formats and get people data' do
    let(:params) do
      {
        dollar_format: File.read('spec/fixtures/people_by_dollar.txt'),
        percent_format: File.read('spec/fixtures/people_by_percent.txt'),
        birthdate: birthdate
      }
    end

    let(:people_controller) { PeopleController.new(params) }

    context 'combine both format and list people data' do
      let(:birthdate) { nil }
      
      it 'list all people data without normalize' do
        people =  people_controller.people_list

        expect(people).to eq [
          {"birthdate"=>"30-4-1974", "city"=>"LA", "first_name"=>"Rhiannon", "last_name"=>"Nolan"},
          {"birthdate"=>"5-1-1962", "city"=>"NYC", "first_name"=>"Rigoberto", "last_name"=>"Bruen"},
          {"birthdate"=>"1986-05-29", "city"=>"Atlanta", "first_name"=>"Mckayla"},
          {"birthdate"=>"1947-05-04", "city"=>"New York City", "first_name"=>"Elliot"}
        ]
      end
    end

    context "list people by younger age" do
      let(:birthdate) { :asc }

      it 'shows all people data sort by birthdate' do
        people =  people_controller.people_sort_by_age

        expect(people).to eq [
          "Elliot, New York City, 04-05-1947",
          "Rigoberto, New York City, 05-01-1962",
          "Rhiannon, Los Angeles, 30-04-1974",
          "Mckayla, Atlanta, 29-05-1986"
        ]
      end
    end

    context "list people by elder age" do
      let(:birthdate) { :desc } 

      it 'shows all people data sort by birthdate' do
        people =  people_controller.people_sort_by_age

        expect(people).to eq [
          "Mckayla, Atlanta, 29-05-1986",
          "Rhiannon, Los Angeles, 30-04-1974",
          "Rigoberto, New York City, 05-01-1962",
          "Elliot, New York City, 04-05-1947"
        ]
      end
    end    
  end
end
