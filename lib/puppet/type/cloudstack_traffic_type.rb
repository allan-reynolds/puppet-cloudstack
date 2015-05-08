# Custom Type: Cloudstack - Traffic Type

Puppet::Type.newtype(:cloudstack_traffic_type) do
  @doc = "Cloudstack Traffic Type"

  ensurable
      
  newparam(:name, :namevar => true) do
    desc "The traffic type name (Format: PhysicalNetwork_TrafficType)"    # Combined fields namevare not possible in puppet ??? STUPID REST API !
  end
    
  newproperty(:physicalnetwork) do
    desc "The physical network to apply the traffic type on."
  end  
  
  newproperty(:traffictype) do
    desc "The traffic type: Guest/Public/Storage/Management"
  end  
  
  newproperty(:label) do 
    desc "The label used by the hypervisor to identify the network interface"
  end  
  
  newparam(:isolationmethod) do
    desc "The isolation method used to split the traffic (vlan/vxlan)"
    defaultto :vlan
  end  
  
  # UNUSED:
#  newproperty(:vmware_vlan) do
#    desc "The VLAN for management traffic on VMWare"
#  end  
end