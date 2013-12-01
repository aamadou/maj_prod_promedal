require '.\access_connector.rb'
require '.\mysql_connector.rb'


puts 'test Access'
db = IntellixAccessDb.new('c:\temp\PROMEDAL2013.mdb','Group')
db.open
produits_access=db.get_produit_diponibility
produits_access.each do |row|
  puts row[:produit]
  puts row[:disponibilite]
end
db.close

puts '**************************************'
puts


puts 'test mysql'
db=IntellixMysqlDb.new()
db.open
db.empty_produit
db.fetch_liste_produits
unproduit='Test'
if db.produit_exist?(unproduit)
   db.delete_produit(unproduit)
end   

db.fetch_liste_produits
db.list_produits.each {|row| puts row.inspect}

unless db.produit_exist?(unproduit)
   db.ajouter_produit(unproduit)
end   

db.fetch_liste_produits
db.list_produits.each {|row| puts row.inspect}

if db.produit_diponible?(unproduit)
   db.update_produit(unproduit,false)
end    

db.fetch_liste_produits
db.list_produits.each {|row| puts row.inspect}

db.update_disponibilite(produits_access)

db.fetch_liste_produits
db.list_produits.each do |row|
   puts eval(row['Designation'].inspect)
   puts row['Disponibilite'].inspect
end   

puts "*** remisejour ***"


db.update_disponibilite(produits_access)

db.fetch_liste_produits
db.list_produits.each do |row|
   puts eval(row['Designation'].inspect)
   puts row['Disponibilite'].inspect
end   

db.close

