# Use this file to import the sales information into the
# the database.
require "pry"
require "pg"
require "csv"

def db_connection
  begin
    connection = PG.connect(dbname: "korning")
    yield(connection)
  ensure
    connection.close
  end
end

db_connection do |conn|
  employee_array = []
  CSV.foreach("sales.csv", headers: true) do |row|
    unless employee_array.include?(row["employee"])
      employee_array << row["employee"]
    end
  end

  employee_array.each do |employee|
    remove = employee.delete "()"
    employee_info = remove.split
    conn.exec("INSERT INTO employees (name, email_address) VALUES
     ('#{employee_info[0]} #{employee_info[1]}', '#{employee_info[2]}');")
   end
end

db_connection do |conn|
  customers_array = []
  CSV.foreach("sales.csv", headers: true) do |row|
    unless customers_array.include?(row["customer_and_account_no"])
      customers_array << row["customer_and_account_no"]
    end
  end

  customers_array.each do |customer|
    remove = customer.delete "()"
    customer_info = remove.split
    conn.exec("INSERT INTO customers (name, account_number) VALUES
     ('#{customer_info[0]}', '#{customer_info[1]}');")
   end
end

db_connection do |conn|
  products_array = []
  CSV.foreach("sales.csv", headers: true) do |row|
    unless products_array.include?(row["product_name"])
      products_array << row["product_name"]
    end
  end

  products_array.each do |product|
    conn.exec("INSERT INTO products (name) VALUES
     ('#{product}');")
   end
end

db_connection do |conn|
  frequencies_array = []
  CSV.foreach("sales.csv", headers: true) do |row|
    unless frequencies_array.include?(row["invoice_frequency"])
      frequencies_array << row["invoice_frequency"]
    end
  end

  frequencies_array.each do |frequency|
    conn.exec("INSERT INTO frequencies (frequency) VALUES
     ('#{frequency}');")
   end
end

db_connection do |conn|
  invoice_array = []
  CSV.foreach("sales.csv", headers: true) do |row|
    unless invoice_array.include?(row["invoice_no"])
      invoice_array << row["invoice_no"]

      remove = row["employee"].delete "()"
      employee_info = remove.split
      employee_name = "#{employee_info[0]} #{employee_info[1]}"
      employee_id = conn.exec("SELECT employees.id FROM employees WHERE employees.name = '#{employee_name}'").first["id"]

      remove = row["customer_and_account_no"].delete "()"
      customer_info = remove.split
      customer_name = "#{customer_info[0]}"
      customer_id = conn.exec("SELECT customers.id FROM customers WHERE customers.name = '#{customer_name}'").first["id"]

      frequency_name = row["invoice_frequency"]
      frequency_id = conn.exec("SELECT frequencies.id FROM frequencies WHERE frequencies.frequency = '#{frequency_name}'").first["id"]

      product_name = row["product_name"]
      product_id = conn.exec("SELECT products.id FROM products WHERE products.name = '#{product_name}'").first["id"]

      conn.exec("INSERT INTO invoices (invoice_num, sale_date, sale_amount,
       units_sold, employee_id, customer_id, product_id, frequency_id) VALUES ('#{row["invoice_no"]}', '#{row["sale_date"]}',
       '#{row["sale_amount"]}', '#{row["units_sold"]}', '#{employee_id}', '#{customer_id}', '#{product_id}', '#{frequency_id}');")
    end
  end
end


# db_connection do |conn|
#   @sale = CSV.readlines("sales.csv", headers: true)
#   @sale.each do |row|
#     remove = row["employee"].delete "()"
#     employee_info = remove.split
#     employee_name = "#{employee_info[0]} #{employee_info[1]}"
#     employee_id = conn.exec("SELECT employees.id FROM employees WHERE employees.name = '#{employee_name}'").first["id"]
#
#     remove = row["customer_and_account_no"].delete "()"
#     customer_info = remove.split
#     customer_name = "#{customer_info[0]}"
#     customer_id = conn.exec("SELECT customers.id FROM customers WHERE customers.name = '#{customer_name}'").first["id"]
#
#     frequency_name = row["invoice_frequency"]
#     frequency_id = conn.exec("SELECT frequencies.id FROM frequencies WHERE frequencies.frequency = '#{frequency_name}'").first["id"]
#
#     product_name = row["product_name"]
#     product_id = conn.exec("SELECT products.id FROM products WHERE products.name = '#{product_name}'").first["id"]
#
#     conn.exec("INSERT INTO invoices (employee_id, customer_id, product_id, frequency_id) VALUES ('#{employee_id}', '#{customer_id}', '#{product_id}', '#{frequency_id}');")
#   end
# end
