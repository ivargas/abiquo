/**
 * Abiquo community edition
 * cloud management application for hybrid clouds
 * Copyright (C) 2008-2010 - Abiquo Holdings S.L.
 *
 * This application is free software; you can redistribute it and/or
 * modify it under the terms of the GNU LESSER GENERAL PUBLIC
 * LICENSE as published by the Free Software Foundation under
 * version 3 of the License
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * LESSER GENERAL PUBLIC LICENSE v.3 for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

package com.abiquo.abiserver.business.hibernate.pojohb.user;

import java.util.HashSet;
import java.util.Set;

import com.abiquo.abiserver.business.hibernate.pojohb.IPojoHB;
import com.abiquo.abiserver.pojo.user.Privilege;
import com.abiquo.abiserver.pojo.user.Role;

// Generated 16-oct-2008 16:52:14 by Hibernate Tools 3.2.1.GA

/**
 * Role generated by hbm2java
 */
public class RoleHB implements java.io.Serializable, IPojoHB<Role>
{

    private static final long serialVersionUID = -5172429643785560320L;

    private Integer idRole;

    private String name;

    private boolean blocked;

    private EnterpriseHB enterpriseHB;

    private String ldap;

    // private Integer idEnterprise;

    private Set<PrivilegeHB> privilegesHB;

    public Set<PrivilegeHB> getPrivilegesHB()
    {
        return privilegesHB;
    }

    public void setPrivilegesHB(final Set<PrivilegeHB> privilegesHB)
    {
        this.privilegesHB = privilegesHB;
    }

    public Integer getIdRole()
    {
        return idRole;
    }

    public void setIdRole(final Integer idRole)
    {
        this.idRole = idRole;
    }

    public String getName()
    {
        return name;
    }

    public void setName(final String name)
    {
        this.name = name;
    }

    public boolean isBlocked()
    {
        return blocked;
    }

    public void setBlocked(final boolean blocked)
    {
        this.blocked = blocked;
    }

    public EnterpriseHB getEnterpriseHB()
    {
        return enterpriseHB;
    }

    public void setEnterpriseHB(final EnterpriseHB enterpriseHB)
    {
        this.enterpriseHB = enterpriseHB;
    }

    public String getLdap()
    {
        return ldap;
    }

    public void setLdap(final String ldap)
    {
        this.ldap = ldap;
    }

    @Override
    public Role toPojo()
    {
        Role role = new Role();

        role.setId(idRole);
        role.setName(name);
        role.setBlocked(blocked);

        role.setLdap(ldap);

        if (enterpriseHB != null)
        {
            role.setEnterprise(enterpriseHB.toPojo());
            role.setIdEnterprise(enterpriseHB.getIdEnterprise());
        }
        else
        {
            role.setEnterprise(null);
        }

        Set<Privilege> privilege = new HashSet<Privilege>();
        if (privilegesHB != null)
        {
            for (PrivilegeHB pHB : privilegesHB)
            {
                privilege.add(pHB.toPojo());
            }
        }

        role.setPrivileges(privilege);

        return role;
    }

}
