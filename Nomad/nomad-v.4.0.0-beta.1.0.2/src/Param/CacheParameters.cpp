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


#include <iomanip>  // For std::setprecision
#include "../Math/RNG.hpp"
#include "../Param/CacheParameters.hpp"

/*----------------------------------------*/
/*         initializations (private)      */
/*----------------------------------------*/
void NOMAD::CacheParameters::init()
{
    _typeName = "Cache";

    try
    {
        #include "../Attribute/cacheAttributesDefinition.hpp"
        registerAttributes( _definition );
    }
    catch ( NOMAD::Exception & e)
    {
        std::string errorMsg = "Attribute registration failed: ";
        errorMsg += e.what();
        throw NOMAD::Exception(__FILE__,__LINE__, errorMsg);
    }
}

/*----------------------------------------*/
/*            check the parameters        */
/*----------------------------------------*/
void NOMAD::CacheParameters::checkAndComply( std::shared_ptr<NOMAD::RunParameters> runParams )
{
    checkInfo();
    
    if (!toBeChecked())
    {
        // Early out
        return;
    }
    
    /*----------------------------*/
    /* Update cache file names    */
    /*----------------------------*/
    auto problemDir = runParams->getAttributeValue<string>("PROBLEM_DIR",false);
    std::string cacheFileName = getAttributeValueProtected<std::string>("CACHE_FILE",false);
    if (!cacheFileName.empty())
    {
        NOMAD::completeFileName(cacheFileName, problemDir);
        setAttributeValue("CACHE_FILE", cacheFileName);
    }

    // Hot restart needs a cache file
    bool hotRestartRead = runParams->getAttributeValue<bool>("HOT_RESTART_READ_FILES", false);
    bool hotRestartWrite = runParams->getAttributeValue<bool>("HOT_RESTART_WRITE_FILES", false);
    if (hotRestartRead || hotRestartWrite)
    {
        if (cacheFileName.empty())
        {
            cacheFileName = "cache.txt";
            std::cerr << "Warning: " << ((hotRestartWrite) ? "HOT_RESTART_WRITE_FILES" : "HOT_RESTART_READ_FILES") << " is set. CACHE_FILE set to \"" << cacheFileName << "\"" << std::endl;

            NOMAD::completeFileName(cacheFileName, problemDir);
            setAttributeValue("CACHE_FILE", cacheFileName);
        }
    }
    
    _toBeChecked = false;
    
}
// End checkAndComply()


