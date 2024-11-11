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
 \file   EvalType.cpp
 \brief  types for Eval (implementation)
 \author Viviane Rochon Montplaisir
 \date   November 2019
 \see    EvalType.hpp
 */

#include "../Type/EvalType.hpp"
#include "../Util/Exception.hpp"
#include "../Util/utils.hpp"


// Convert a string ("BB", "SGTE")
// to a NOMAD::EvalType.
// "UNDEFINED" throws an exception, as well as any value other than "BB" or "SGTE".
NOMAD::EvalType NOMAD::stringToEvalType(const std::string &sConst)
{
    NOMAD::EvalType ret;
    std::string s = sConst;
    NOMAD::toupper(s);

    if (s == "BB")
    {
        ret = NOMAD::EvalType::BB;
    }
    else if (s == "SGTE")
    {
        ret = NOMAD::EvalType::SGTE;
    }
    else
    {
        throw NOMAD::Exception(__FILE__, __LINE__, "Unrecognized string for NOMAD::EvalType: " + s);
    }

    return ret;
}


// Convert a NOMAD::EvalType to a string.
// NOMAD::EvalType::UNDEFINED returns "UNDEFINED".
// An unrecognized eval type returns an exception.
std::string NOMAD::evalTypeToString(const NOMAD::EvalType& evalType)
{
    std::string s;

    switch(evalType)
    {
        case NOMAD::EvalType::BB:
            s = "BB";
            break;
        case NOMAD::EvalType::SGTE:
            s = "SGTE";
            break;
        case NOMAD::EvalType::UNDEFINED:
            s = "UNDEFINED";
            break;
        default:
            throw NOMAD::Exception(__FILE__, __LINE__, "Unrecognized NOMAD::EvalType " + std::to_string((int)evalType));
            break;
    }

    return s;
}

