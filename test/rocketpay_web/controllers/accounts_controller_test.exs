defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase

  alias Rocketpay.User
  alias Rocketpay.Account

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "Irineu",
        password: "123456",
        nickname: "iri",
        email: "irineu@gmail.com",
        age: 44
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      conn = put_req_header(conn, "authorization", "Basic YWRtaW46YWRtaW4=")

      {:ok, conn: conn, account_id: account_id}
    end

    test "whem all params are valid, make the deposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => "50.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:ok)

      assert %{
               "account" => %{"balance" => "50.00", "id" => _id},
               "message" => "Balance changed successfully"
             } = response
    end

    test "whem there are invalid params, returns an error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "skibdi"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invald deposit value"}

      assert response == expected_response
    end
  end
end
