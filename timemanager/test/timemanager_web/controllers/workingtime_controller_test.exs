# defmodule TimemanagerWeb.WorkingtimeControllerTest do
#   use TimemanagerWeb.ConnCase

#   import Timemanager.WorkingtimesFixtures

#   alias Timemanager.Workingtimes.Workingtime

#   @create_attrs %{
#     start_time: ~N[2023-10-23 09:17:00],
#     end_time: ~N[2023-10-23 09:17:00]
#   }
#   @update_attrs %{
#     start_time: ~N[2023-10-24 09:17:00],
#     end_time: ~N[2023-10-24 09:17:00]
#   }
#   @invalid_attrs %{start_time: nil, end_time: nil}

#   setup %{conn: conn} do
#     {:ok, conn: put_req_header(conn, "accept", "application/json")}
#   end

#   describe "index" do
#     test "lists all workingtimes", %{conn: conn} do
#       conn = get(conn, ~p"/api/working")
#       assert json_response(conn, 200)["data"] == []
#     end
#   end

#   describe "create workingtime" do
#     test "renders workingtime when data is valid", %{conn: conn} do
#       conn = post(conn, ~p"/api/working", workingtime: @create_attrs)
#       assert %{"id" => id} = json_response(conn, 201)["data"]

#       conn = get(conn, ~p"/api/working/#{id}")

#       assert %{
#                "id" => ^id,
#                "end_time" => "2023-10-23T09:17:00",
#                "start_time" => "2023-10-23T09:17:00"
#              } = json_response(conn, 200)["data"]
#     end

#     test "renders errors when data is invalid", %{conn: conn} do
#       conn = post(conn, ~p"/api/working", workingtime: @invalid_attrs)
#       assert json_response(conn, 422)["errors"] != %{}
#     end
#   end

#   describe "update workingtime" do
#     setup [:create_workingtime]

#     test "renders workingtime when data is valid", %{conn: conn, workingtime: %Workingtime{id: id} = workingtime} do
#       conn = put(conn, ~p"/api/working/#{workingtime}", workingtime: @update_attrs)
#       assert %{"id" => ^id} = json_response(conn, 200)["data"]

#       conn = get(conn, ~p"/api/working/#{id}")

#       assert %{
#                "id" => ^id,
#                "end_time" => "2023-10-24T09:17:00",
#                "start_time" => "2023-10-24T09:17:00"
#              } = json_response(conn, 200)["data"]
#     end

#     test "renders errors when data is invalid", %{conn: conn, workingtime: workingtime} do
#       conn = put(conn, ~p"/api/working/#{workingtime}", workingtime: @invalid_attrs)
#       assert json_response(conn, 422)["errors"] != %{}
#     end
#   end

#   describe "delete workingtime" do
#     setup [:create_workingtime]

#     test "deletes chosen workingtime", %{conn: conn, workingtime: workingtime} do
#       conn = delete(conn, ~p"/api/working/#{workingtime}")
#       assert response(conn, 204)

#       assert_error_sent 404, fn ->
#         get(conn, ~p"/api/working/#{workingtime}")
#       end
#     end
#   end

#   defp create_workingtime(_) do
#     workingtime = workingtime_fixture()
#     %{workingtime: workingtime}
#   end
# end
