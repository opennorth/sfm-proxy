get %r{/people/([a-f0-9]{8}-[a-f0-9]{4}-[1-5][a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}).zip} do |id|
  204
end
get %r{/people/([a-f0-9]{8}-[a-f0-9]{4}-[1-5][a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}).txt} do |id|
  204
end

# @drupal Load node from Drupal.
get '/people/:id' do
  content_type 'application/json'

  result = connection[:people].find(_id: params[:id]).first

  if result
    memberships = result['memberships'].map do |membership|
      item = membership.except('organization', 'site_id', 'site')

      item['organization'] = if membership['organization']
        {
          "name" => membership['organization']['name']['value'],
        }
      else
        {
          "name" => membership['organization_id']['value'],
        }
      end

      item
    end

    memberships.sort! do |a,b|
      b['date_first_cited'].try(:[], 'value') <=> a['date_first_cited'].try(:[], 'value')
    end

    site = if memberships[0]['site_id']
      {
        "name" => memberships[0]['site_id']['value']
      }
    elsif memberships[0]['organization']
      { # @hardcoded
        "type" => "Feature",
        "id" => "5947d0de-626d-495f-9c31-eb2ca5afdb6b",
        "name" => "Command Center",
        "admin_level_1" => "Abia",
        "admin_level_2" => "Abia North",
        "sources" => [
          "..."
        ],
        "confidence" => "Medium",
      }
    end

    etag_and_return({
      "id" => result['_id'],
      "division_id" => result['division_id'],
      "name" => result['name'],
      "other_names" => result['other_names'],
      "memberships" => memberships,
      "area_present" => {
        "type" => "Feature",
        "id" => memberships[0]['organization']['id'],
        "properties" => {},
        "geometry" => organization_geometry(memberships[0]['organization']),
      },
      "site_present" => site,
      # Add events related to an organization during the membership of the person.
      "events" => [ # @hardcoded
        {
          "id" => 'eba734d7-8078-4af5-ae8f-838c0d47fdc0',
          "start_date" => '2010-01-01',
          "end_date" => nil,
          "admin_level_1" => 'Abia',
          "admin_level_2" => 'Abia North',
          "classification" => ['Torture', 'Disappearance'],
          "perpetrator_name" => 'Terry Guerrier',
          "perpetrator_organization" => {
            "id" => '123e4567-e89b-12d3-a456-426655440000',
            "name" => 'Brigade 2',
          }
        }
      ],
      # Add events near an organization during the membership of the person.
      "events_nearby" => [ # @hardcoded
        {
          "id" => 'eba734d7-8078-4af5-ae8f-838c0d47fdc0',
          "start_date" => '2010-01-01',
          "end_date" => nil,
          "admin_level_1" => 'Abia',
          "admin_level_2" => 'Abia North',
          "classification" => ['Torture', 'Disappearance'],
          "perpetrator_name" => 'Terry Guerrier',
          "perpetrator_organization" => {
            "id" => '123e4567-e89b-12d3-a456-426655440000',
            "name" => 'Brigade 2',
          }
        }
      ]
    })
  else
    404
  end
end
