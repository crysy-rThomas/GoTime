defmodule TimemanagerWeb.LoginJSON do


  def login(%{token: token}) do
    %{data: %{token: token}}
  end

  def error(%{error: error}) do
    %{data: %{error: error}}
  end
end
