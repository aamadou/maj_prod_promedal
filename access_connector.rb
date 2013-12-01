require 'win32ole'
 class IntellixAccessDb
  attr_accessor :mdb, :connection, :data, :fields, :password
  def initialize(mdb=nil, password = nil)
    @mdb = mdb
    @connection = nil
    @data = nil
    @fields = nil
    @password = password
  end

  def open
    conn_options = [ "Provider=Microsoft.ACE.OLEDB.12.0",
      "Data Source=#{@mdb}"]
    conn_options << "Jet OLEDB:Database Password=#{@password}" if @password
    @connection = WIN32OLE.new('ADODB.Connection')
    @connection.Open(conn_options.join(";"))
  end

  def query(sql)
    recordset = WIN32OLE.new('ADODB.Recordset')
    recordset.Open(sql, @connection)
    @fields = []
    recordset.Fields.each do |field|
      @fields << field.Name
    end
    begin
      @data = recordset.GetRows.transpose
    rescue
      @data = []
    end
    recordset.Close
  end

  def execute(sql)
    @connection.Execute(sql)
  end

  def close
    @connection.Close
  end
  
  def get_produit_diponibility
    self.query("SELECT * FROM Produit;")
    field_names = self.fields
    rows = self.data
    product_list=rows.map {|row| {:produit => row[3],:disponibilite => (row[7]>=1)} }
  end
  
end
