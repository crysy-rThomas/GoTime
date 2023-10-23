defmodule TimemanagerWeb.Swagger do
  use PhoenixSwagger

  @moduledoc """
  This module provides the OpenAPI specifications for the Time Manager application.
  """

  def swagger_info do
    %{
      info: %{
        version: "0.1.0",
        title: "Time Manager API",
        description: "API for the Time Manager application"
      }
    }
  end

  # Example API endpoint definition:
  #
  #swagger_path :index do
  #  get("/api/sample_endpointuser") do
  #    summary("Sample API endpoint")
  #    response(200, "OK", Schema.ref(:SampleResponse))
  #  end
  #end

  defmodule Schema do
    use PhoenixSwagger.Schema

    def sample_response do
      %{
        type: "object",
        properties: %{
          message: %{
            type: "string",
            description: "Sample message"
          }
        }
      }
    end
  end
end
