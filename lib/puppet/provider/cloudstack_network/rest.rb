require File.join(File.dirname(__FILE__), '..', 'cloudstack_rest')

Puppet::Type.type(:cloudstack_network).provide :rest, :parent => Puppet::Provider::Rest do
  desc "REST provider for Cloudstack Network"
  
  mk_resource_methods
  
  def flush    
    if @property_flush[:ensure] == :present
      createNetwork
      return
    end
    
    if @property_flush[:ensure] == :absent
      deleteNetwork
      return
    end 

    updateNetwork
  end  

  def self.instances
    list = get_objects(:listNetworks, "network")
    if list == nil
      return Array.new
    end   
     
    result = Array.new  
    list.each do |object|    
      map = getNetwork(object)
      if map != nil
        Puppet.debug "Network: "+map.inspect
        result.push(new(map))
      end
    end 

    result 
  end
  
  def self.getObject(name) 
    params = { :name => name }
    get_objects(:listNetworks, "network", params).collect do |object|    
      return getNetwork(object)
    end
  end
    
  def self.getNetwork(object) 
    tags = convertCSVtoArray(object["tags"])
      
    zone = self.class.genericLookup(:listZones, 'zone', 'id', object["zoneid"], {}, 'name')
    domain = self.class.genericLookup(:listDomains, 'domain', 'id', object["domainid"], {}, 'name') unless object["domainid"] == nil
    
    if object["name"] != nil  
      {
        :id               => object["id"],
        :name             => object["name"],   
        :zoneid           => object["zoneid"],
        :zone             => zone, 
        :domainid         => object["domainid"],
        :domain           => domain,  
        :isolationmethods => object["isolationmethods"],
        :vlan             => object["vlan"], 
        :tags             => tags,
        :ensure           => :present
      }
    end
  end
  
  # TYPE SPECIFIC      
  private
  def createNetwork
    Puppet.debug "Create Network "+resource[:name]
 
    zoneid = self.class.genericLookup(:listZones, 'zone', 'name', resource[:zone], {}, 'id')
      
    params = {         
      :name               => resource[:name],   
      :zoneid             => zoneid,           
      :isolationmethods   => resource[:isolationmethods],   
      :vlan               => resource[:vlan],   
      :tags               => resource[:tags].join(","), 
    }
    
    if resource[:domain] != nil
      domainid = self.class.genericLookup(:listDomains, 'domain', 'name', resource[:domain], {}, 'id')
      params[:domainid] = domainid
    end
            
    Puppet.debug "createNetwork PARAMS = "+params.inspect
    #response = self.class.http_get('createNetwork', params)
  end

  def deleteNetwork
    Puppet.debug "Delete Network "+resource[:name]
      
    id = lookupId
     
    params = { 
      :id => id,
    }
    Puppet.debug "deleteNetwork PARAMS = "+params.inspect
#    response = self.class.http_get('deleteNetwork', params)           
    
#    self.class.wait_for_async_call(response["jobid"])
  end
  
  def updateNetwork
    Puppet.debug "Update Network "+resource[:name]
      
    currentObject = self.class.getObject(@property_hash[:name])
            
    if resource[:tags] != currentObject[:tags] or resource[:vlan] != currentObject[:vlan]
      id = lookupId
      params = { 
        :id      => id,   
        :vlan    =>  resource[:vlan],    
        :tags    => resource[:tags].join(","),  
      }
      Puppet.debug "updateNetwork PARAMS = "+params.inspect
#      response = self.class.http_get('updateNetwork', params)    
     
#      self.class.wait_for_async_call(response["jobid"])
    else 
      raise "Only tags and vlan can be updated for Network !!!"  
    end
  end  
  
  def lookupId 
    return self.class.genericLookup(:listNetworks, 'network', 'name', resource[:name], {}, 'id')    # NAME IS NOT ID !!!
  end
end