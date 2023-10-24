defmodule TimemanagerWeb.TaskControllerTest do
  use TimemanagerWeb.ConnCase

  import Timemanager.TasksFixtures

  alias Timemanager.Tasks.Task

  @create_attrs %{
<<<<<<< HEAD
    status: 42,
=======
>>>>>>> 59688609fb43e4d8fbc507e69fe6932cef6a2633
    description: "some description",
    title: "some title"
  }
  @update_attrs %{
<<<<<<< HEAD
    status: 43,
    description: "some updated description",
    title: "some updated title"
  }
  @invalid_attrs %{status: nil, description: nil, title: nil}
=======
    description: "some updated description",
    title: "some updated title"
  }
  @invalid_attrs %{description: nil, title: nil}
>>>>>>> 59688609fb43e4d8fbc507e69fe6932cef6a2633

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tasks", %{conn: conn} do
      conn = get(conn, ~p"/api/tasks")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create task" do
    test "renders task when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/tasks", task: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/tasks/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some description",
<<<<<<< HEAD
               "status" => 42,
=======
>>>>>>> 59688609fb43e4d8fbc507e69fe6932cef6a2633
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/tasks", task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update task" do
    setup [:create_task]

    test "renders task when data is valid", %{conn: conn, task: %Task{id: id} = task} do
      conn = put(conn, ~p"/api/tasks/#{task}", task: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/tasks/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some updated description",
<<<<<<< HEAD
               "status" => 43,
=======
>>>>>>> 59688609fb43e4d8fbc507e69fe6932cef6a2633
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, task: task} do
      conn = put(conn, ~p"/api/tasks/#{task}", task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete task" do
    setup [:create_task]

    test "deletes chosen task", %{conn: conn, task: task} do
      conn = delete(conn, ~p"/api/tasks/#{task}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/tasks/#{task}")
      end
    end
  end

  defp create_task(_) do
    task = task_fixture()
    %{task: task}
  end
end