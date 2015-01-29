class DocumentsHelperController < ApplicationController
	require 'csv'
	def xls_to_json file_name
	    excel_path = file_name
	    json_path = file_name.split('.').first + ".json"
	    sheet_number = 1 # sheet number start from 0
	    header_row_number = 1 # row number of the header row which contains column names. 
	                      # Rows before this number get ignored. 
	                      # Row numbers start from 1 based on Excel conventions.

	    Xlsx2json::Transformer.execute excel_path, sheet_number, json_path, header_row_number: header_row_number

	    JSON.parse(File.open(json_path).read)
	end

	def csv_to_json file_name
	    csv_path = file_name
	    csv_content = File.read(csv_path)
	    headers = nil
	    array = []
	    result_hash = []
	    csv_content.lines.each do |line|
	    	array_line = line.gsub("\n", '').split(',')
	    	if line == csv_content.lines.first
	    		headers = array_line
	    	else
		    	hash = {}
		    	headers.each_with_index do |header, index|
		    		hash[header] = array_line[index]
		    	end
		    	result_hash << hash
		    end
	    end
	    result_hash
	end

	#rails g model sector nombre:string sector:string comuna:references
	def read_sectors
		json = xls_to_json	'public/uploads/document/sector.xlsx'
		comunas = Comuna.all
		Sector.delete_all
		json.each do |data|
			unless data["nombre_comuna"].nil?
				comuna = comunas.select{|comuna| comuna.nombre.casecmp(data["nombre_comuna"]) == 0}.first
				Sector.create(nombre: data["nombre_sector"], sector: data["cod_sector"], comuna: comuna)
			end
		end
	end

	#rails g model comuna nombre:string provincia:references
	def read_comunas
		json = csv_to_json	'public/uploads/document/comunas.csv'
		Comuna.delete_all
		json.each do |data|
			Comuna.create(nombre: data["nombre"], provincia_id: data["provincia_id"], id: data["id"])
		end
	end

	#rails g model provincia nombre:string region:references
	def read_provincias
		json = csv_to_json 'public/uploads/document/provincias.csv'
		Provincium.delete_all
		json.each do |data|
			Provincium.create(nombre: data["nombre"], region_id: data["region_id"], id: data["id"])
		end
	end

	#rails g model region numero:string nombre:string titulo:string
	def read_regions
		json = csv_to_json 'public/uploads/document/regions.csv'
		Region.delete_all
		json.each do |data|
			Region.create(data)
		end

	end
end
