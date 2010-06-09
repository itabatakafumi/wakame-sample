define_cluster('WebCluster1') { |c|
  #Railsアプリのリソース
  c.add_resource(Apache_APP.new) { |r|
    r.listen_port = 8001
    r.max_instances = 5
  }
  #Apache2のリソース
  c.add_resource(Apache_WWW.new) { |r|
    r.listen_port = 8001
    r.max_instances = 5
  }
  #ELBのリソース
  c.add_resource(Ec2ELB.new) { |r|
    r.elb_name = 'spree-elb'
  }
  
  c.set_dependency(Apache_APP, Ec2ELB)
  c.set_dependency(Apache_WWW, Ec2ELB)

  host = c.add_cloud_host { |h|
    #h.vm_spec.availability_zone = 'us-east-1a'
  }
  c.propagate(Apache_WWW, host.id)
  c.propagate(Apache_APP, host.id)
  c.propagate(Ec2ELB)

  c.define_triggers {|r|
    #r.register_trigger(Wakame::Triggers::MaintainSshKnownHosts.new)
    #r.register_trigger(Wakame::Triggers::LoadHistoryMonitor.new)
    #r.register_trigger(Wakame::Triggers::InstanceCountUpdate.new)
    #r.register_trigger(Wakame::Triggers::ScaleOutWhenHighLoad.new)
    #r.register_trigger(Wakame::Triggers::ShutdownUnusedVM.new)
  }
}
