# requirements
sudo yum install -y checkpolicy

# to apply policy:
cat > mongodb_cgroup_memory.te <<EOF
module mongodb_cgroup_memory 1.0;
require {
      type cgroup_t;
      type mongod_t;
      class dir search;
      class file { getattr open read };
}
#============= mongod_t ==============
allow mongod_t cgroup_t:dir search;
allow mongod_t cgroup_t:file { getattr open read };
EOF

checkmodule -M -m -o mongodb_cgroup_memory.mod mongodb_cgroup_memory.te
semodule_package -o mongodb_cgroup_memory.pp -m mongodb_cgroup_memory.mod
sudo semodule -i mongodb_cgroup_memory.pp

cat > mongodb_proc_net.te <<EOF
module mongodb_proc_net 1.0;

require {
    type cgroup_t;
    type configfs_t;
    type file_type;
    type mongod_t;
    type proc_net_t;
    type sysctl_fs_t;
    type var_lib_nfs_t;

    class dir { search getattr };
    class file { getattr open read };
}

#============= mongod_t ==============
allow mongod_t cgroup_t:dir { search getattr } ;
allow mongod_t cgroup_t:file { getattr open read };
allow mongod_t configfs_t:dir getattr;
allow mongod_t file_type:dir { getattr search };
allow mongod_t file_type:file getattr;
allow mongod_t proc_net_t:file { open read };
allow mongod_t sysctl_fs_t:dir search;
allow mongod_t var_lib_nfs_t:dir search;
EOF

checkmodule -M -m -o mongodb_proc_net.mod mongodb_proc_net.te
semodule_package -o mongodb_proc_net.pp -m mongodb_proc_net.mod
sudo semodule -i mongodb_proc_net.pp

# to uninstall policy:
# sudo make uninstall