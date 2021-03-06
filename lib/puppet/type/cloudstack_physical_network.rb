# Custom Type: Cloudstack - Physical Network

Puppet::Type.newtype(:cloudstack_physical_network) do
  @doc = "Cloudstack Physical Network"

  ensurable do
    defaultto :present
 
    newvalue(:present) do
      provider.setState(:present)      
    end
     
    newvalue(:enabled) do
      provider.setState(:enabled)
    end
        
    newvalue(:disabled) do
      provider.setState(:disabled)
    end
     
    newvalue(:absent) do
      provider.setState(:absent)      
    end
         
    def insync?(is)
      @should.each { |should| 
        case should
          when :present
            return true unless [:absent].include?(is)
          when :absent
            return true if is == :absent
          when :enabled
            return false if is == :absent                          
            return (provider.getState == "enabled")
          when :disabled
            return false if is == :absent                          
            return (provider.getState == "disabled")       
        end
      }            
      false             
    end
  end
      
  newparam(:name, :namevar => true) do
    desc "The physical network name"    
  end
    
  newproperty(:zone) do   # ID
    desc "The zone that this physical network belongs to"
  end  
  
  newproperty(:domain) do  # ID
    desc "The domain that this physical network belongs to"
  end  
  
  newproperty(:isolationmethods) do
    desc "The isolation method (VLAN/GRE/L3)"
  end  
  
  newproperty(:vlan) do
    desc "The VLAN tag (range) for guest traffic"
  end  
  
  newproperty(:tags, :array_matching => :all) do
    desc "The network tags"
  end  
  
  # UNUSED:
    # networkspeed (1G)
    # broadcastdomainrange [Zone => Advanced / Pod => Basic]
end