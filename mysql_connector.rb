require 'mysql2'

class IntellixMysqlDb
  attr_accessor :database, :password, :username, :port, :host, :connection, :list_produits
  def initialize(database='export_intellix', password='amadoux', username='root', port='3307', host='192.168.0.123')
    @database=database
    @password=password
    @username=username
    @port=port
    @host=host
    @connection=nil
    @list_produits=nil
  end

  def open
    @connection = Mysql2::Client.new(:host => @host,:port =>@port, :username => @username, :password =>@password, :database=>@database)
  end

  def close
    @connection.close
  end

  def fetch_liste_produits
    result='pas de connection!!'
    return result if @connection==nil
    @list_produits=@connection.query('SELECT * from produit')
    result=@list_produits
  end

  def produit_exist?(unproduit)
    result=false
    unproduit||=''
    return result if unproduit==''
    unproduit=@connection.escape(unproduit)
    check=@connection.query("SELECT * FROM produit where Designation='#{unproduit}'")
    result=(check.count >=1)
    return result
  end

  def empty_produit
    @connection.query("DELETE FROM produit where true")
  end

  def ajouter_produit(unproduit,diponibilite=true,seuil=1)
    unproduit||=''
    return nil if unproduit==''
    unproduit=@connection.escape(unproduit)
    @connection.query("INSERT INTO produit (Designation,Disponibilite,Seuil) VALUES('#{unproduit}',#{diponibilite},#{seuil})")
    result=(@connection.affected_rows==1)
  end

  def update_produit(unproduit,diponibilite)
    unproduit||=''
    return nil if unproduit==''
    unproduit=@connection.escape(unproduit)
    @connection.query("UPDATE produit SET Disponibilite=#{diponibilite} where Designation='#{unproduit}'")
    result=(@connection.affected_rows==1)
  end

  def delete_produit(unproduit)
    unproduit||=''
    return nil if unproduit==''
    unproduit=@connection.escape(unproduit)
    @connection.query("DELETE FROM produit where Designation='#{unproduit}'")
    result=(@connection.affected_rows==1)
  end

  def produit_diponible?(unproduit)
    result=false
    unproduit||=''
    return result if unproduit==''
    unproduit=@connection.escape(unproduit)
    check=@connection.query("SELECT * FROM produit where Designation='#{unproduit}'")
    check.each do |row|
      result=(row['Disponibilite']==1)
    end
    return result
  end

  def create_une_miseajour
    result=0
  # return le id de la miseajour
  end

  def eupdate_une_miseajoue(id_miseajour,new_produits,updated_produits,total_produits)
    # mettre à jour les compteurs de la miseajour
  end

  def enregistrer_etat_produit(id_miseajour,produit,etat)
    # enregistrer le changement de l'ettat d'un produit
  end

  def update_disponibilite(produits)
    new_produits=0
    updated_produits=0
    total_produits=0
    id_miseajour=self.create_une_miseajour
    produits.each do |row|
      next unless row[:produit]!=''
      unless (produit_exist? row[:produit])
        if (row[:disponibilite]==true)
          # nouveau produit
          ajouter_produit(row[:produit],row[:disponibilite])
          new_produits+=1
          total_produits+=1
          enregistrer_etat_produit(id_miseajour,row[:produit],'nouveau')
        end
      else
        if row[:disponibilite]^produit_diponible?(row[:produit])
          update_produit(row[:produit],row[:disponibilite])
          updated_produits+=1
          total_produits+=1
          if row[:disponibilite]==true
            #etat= enstock
            enregistrer_etat_produit(id_miseajour,row[:produit],'enstock')
          else
          #etat = rupture
            enregistrer_etat_produit(id_miseajour,row[:produit],'rupture')
          end
        end
      end #unless (produit_exist? row[:produit])
    end #each
  end

end
