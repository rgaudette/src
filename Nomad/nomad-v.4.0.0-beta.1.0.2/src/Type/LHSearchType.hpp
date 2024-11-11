/*---------------------------------------------------------------------------------*/
/*  NOMAD - Nonlinear Optimization by Mesh Adaptive Direct Search -                */
/*                                                                                 */
/*  NOMAD - Version 4.0.0 has been created by                                      */
/*                 Viviane Rochon Montplaisir  - Polytechnique Montreal            */
/*                 Christophe Tribes           - Polytechnique Montreal            */
/*                                                                                 */
/*  The copyright of NOMAD - version 4.0.0 is owned by                             */
/*                 Sebastien Le Digabel        - Polytechnique Montreal            */
/*                 Viviane Rochon Montplaisir  - Polytechnique Montreal            */
/*                 Christophe Tribes           - Polytechnique Montreal            */
/*                                                                                 */
/*  NOMAD v4 has been funded by Rio Tinto, Hydro-Québec, NSERC (Natural Science    */
/*  and Engineering Research Council of Canada), INOVEE (Innovation en Energie     */
/*  Electrique and IVADO (The Institute for Data Valorization)                     */
/*                                                                                 */
/*  NOMAD v3 was created and developed by Charles Audet, Sebastien Le Digabel,     */
/*  Christophe Tribes and Viviane Rochon Montplaisir and was funded by AFOSR       */
/*  and Exxon Mobil.                                                               */
/*                                                                                 */
/*  NOMAD v1 and v2 were created and developed by Mark Abramson, Charles Audet,    */
/*  Gilles Couture, and John E. Dennis Jr., and were funded by AFOSR and           */
/*  Exxon Mobil.                                                                   */
/*                                                                                 */
/*  Contact information:                                                           */
/*    Polytechnique Montreal - GERAD                                               */
/*    C.P. 6079, Succ. Centre-ville, Montreal (Quebec) H3C 3A7 Canada              */
/*    e-mail: nomad@gerad.ca                                                       */
/*    phone : 1-514-340-6053 #6928                                                 */
/*    fax   : 1-514-340-5665                                                       */
/*                                                                                 */
/*  This program is free software: you can redistribute it and/or modify it        */
/*  under the terms of the GNU Lesser General Public License as published by       */
/*  the Free Software Foundation, either version 3 of the License, or (at your     */
/*  option) any later version.                                                     */
/*                                                                                 */
/*  This program is distributed in the hope that it will be useful, but WITHOUT    */
/*  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or          */
/*  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License    */
/*  for more details.                                                              */
/*                                                                                 */
/*  You should have received a copy of the GNU Lesser General Public License       */
/*  along with this program. If not, see <http://www.gnu.org/licenses/>.           */
/*                                                                                 */
/*  You can find information on the NOMAD software at www.gerad.ca/nomad           */
/*---------------------------------------------------------------------------------*/
/**
 \file   LHSearchType.hpp
 \brief  Type for parameter LH_SEARCH
 \author Viviane Rochon Montplaisir
 \date   January 2019
 \see    LHSearchType.cpp
 */


#ifndef __NOMAD400_LH_SEARCH_TYPE__
#define __NOMAD400_LH_SEARCH_TYPE__

#include <string>
#include <sstream>

#include "../nomad_nsbegin.hpp"

/// Class for handling the types of LH search.
/**
  *  An initial LH search can be used instead of providing X0. \n
  *  The secondary LH searches can be done at each iteration if no
    other searches has obtained a success.
 */
class LHSearchType
{
private:
    bool    _enable;    ///< Flag for calling LH search.
    size_t  _lhsearch0; ///< Number of points for initial LH search.
    size_t  _lhsearch1; ///< Number of points for secondary LH searches.

public:
    /// Constructor
    /**
     \param entries The parameters for initial search and secondary searches given as a \c string -- \b IN.
     */
    LHSearchType(const std::string& entries = "") ;


    /// Test if LH search is enabled
    /**
     \return \c true if LH search is enabled \c false if not.
     */
    bool isEnabled() const { return _enable; }

    /// Number of initial LH search points
    /**
     \return The number of points for initial LH search.
     */
    size_t getNbInitial() const { return _lhsearch0; }

    /// Number of secondary LH search points at each iteration
    /**
     \return The number of points for secondary LH searches.
     */
    size_t getNbIteration() const { return _lhsearch1; }
    
    /// Comparison operator \c ==.
    /**
     \param lhst    The right-hand side object -- \b IN.
     \return        A boolean equal to \c true if  \c *this \c == \c array.
     */
    bool operator== (const LHSearchType & lhst) const
    {
        return (( _enable == lhst._enable) && ( _lhsearch0 == lhst._lhsearch0 ) && ( _lhsearch1 == lhst._lhsearch1 )) ;
    }
    
    /// Comparison operator \c !=.
    /**
     \param lhst    The right-hand side object -- \b IN.
     \return        A boolean equal to \c true if  \c *this \c != \c array.
     */
    bool operator!= (const LHSearchType &lhst ) const { return !(*this == lhst); }
    
    
};


inline std::ostream& operator<<(std::ostream& os, const LHSearchType &lhsearch)
{
    os << lhsearch.getNbInitial() << " " << lhsearch.getNbIteration();

    return os;
}


#include "../nomad_nsend.hpp"

#endif  // __NOMAD400_LH_SEARCH_TYPE__
