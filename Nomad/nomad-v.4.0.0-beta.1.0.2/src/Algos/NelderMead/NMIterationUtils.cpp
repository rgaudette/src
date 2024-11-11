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

#include "../../Algos/NelderMead/NMIterationUtils.hpp"
#include "../../Algos/NelderMead/NMIteration.hpp"
#include "../../Math/MatrixUtils.hpp"


void NOMAD::NMIterationUtils::setStopReason ( ) const
{
    auto nmStopReason = NOMAD::AlgoStopReasons<NOMAD::NMStopType>::get ( _parentStep->getAllStopReasons() );
    
    if ( nmStopReason == nullptr )
        throw NOMAD::Exception(__FILE__,__LINE__,"NMReflect must have a NM stop reason.");
    
    
    switch ( _currentStepType )
    {
        case NMStepType::REFLECT:
            nmStopReason->set( NOMAD::NMStopType::REFLECT_FAILED );
            break;
        case NMStepType::EXPAND:
            nmStopReason->set( NOMAD::NMStopType::EXPANSION_FAILED );
            break;
        case NMStepType::OUTSIDE_CONTRACTION:
            nmStopReason->set( NOMAD::NMStopType::OUTSIDE_CONTRACTION_FAILED);
            break;
        case NMStepType::INSIDE_CONTRACTION:
            nmStopReason->set( NOMAD::NMStopType::INSIDE_CONTRACTION_FAILED );
            break;
        case NMStepType::SHRINK:
            nmStopReason->set( NOMAD::NMStopType::SHRINK_FAILED );
            break;
        case NMStepType::INSERT_IN_Y:
            nmStopReason->set( NOMAD::NMStopType::INSERTION_FAILED );
            break;
        default:
            nmStopReason->set( NOMAD::NMStopType::UNDEFINED_STEP );
            break;
    }
}


/*----------------------------------------------------------------------*/
/* Get the rank of the matrix DZ = [(y1-y0) (y2-y0) ... (yk-y0)]]       */
/*----------------------------------------------------------------------*/
int NOMAD::NMIterationUtils::getRankDZ( ) const
{
    if ( nullptr == _nmY )
        NOMAD::Exception(__FILE__, __LINE__, "The iteration utils must have a simplex to work with");
    
    // The dimension of DZ (k) is related to Y
    size_t k = _nmY->size() - 1 ;
    
    std::set<EvalPoint>::iterator itY = _nmY->begin();
    
    const NOMAD::Point & y0 = (*itY);
    const size_t dim = y0.size();
    
    // DZ : vector of yk-y0 (multidimensional array)
    double ** DZ = new double *[k];
    for (size_t i = 0 ; i < k ; ++i )
        DZ[i]=new double [dim];
    
    // For debugging
    std::ostringstream outDbg;
    outDbg << "The rank of DZ=[";
    
    
    // Create DZ
    ++itY;
    size_t j=0;
    while ( j < k )
    {
        outDbg << " (" ;
        for ( size_t i = 0; i < dim ; i++ )
        {
            DZ[j][i] = ((*itY)[i].todouble() - y0[i].todouble()  );
            outDbg << DZ[j][i] << " ";
        }
        j++;
        ++itY;
        outDbg << ")" ;
        
    }
    
    // Get the rank
    int rank= NOMAD::getRank(DZ , k , dim , _rankEps.todouble() );
    
    outDbg << " ] equals " << rank;
    
    NOMAD::OutputQueue::Add(outDbg.str(), NOMAD::OutputLevel::LEVEL_DEBUG);
    
    for (size_t i=0 ; i < k ; ++i)
        delete [] DZ[i];;
    delete [] DZ;
    
    return rank;
}

/*---------------------------------------------------------*/
/*---------------------------------------------------------*/
void NOMAD::NMIterationUtils::updateYCharacteristics()
{
    if ( nullptr == _nmY )
        NOMAD::Exception(__FILE__, __LINE__, "The iteration utils must have a simplex to work with");
    
    // Update Y diameter
    // -----------------
    updateYDiameter();
    
    
    // Update Y volumes
    // ----------------
    _simplexVon = -1;
    _simplexVol = -1;
    
    std::set<NOMAD::EvalPoint>::iterator it1 = _nmY->begin();
    const size_t dim = (*it1).size();
    
    if ( _nmY->size() != dim + 1 )
        NOMAD::Exception(__FILE__, __LINE__, "Cannot get the volume of simplex Y when its dimension is not dimPb+1");
    
    const NOMAD::Point * y0 = (*it1).getX(); // y0: first element of Y
    
    if ( y0->size() != dim )
        NOMAD::Exception(__FILE__, __LINE__, "Cannot get the volume of simplex Y when dimension of an element is not dimPb");
    
    // Update volume
    //---------------
    
    // V : vector of yk-y0 ( for determinant, need square array (n x n) )
    double ** V = new double *[dim];
    for (size_t i = 0 ; i < dim ; i++ )
    {
        V[i] = new double [dim];
    }
    
    int j = 0;
    ++it1; // Go the second element of Y
    while ( it1 != _nmY->end() )
    {
        for ( size_t i = 0; i < dim ; i++ )
        {
            V[j][i] =  ( (*it1)[i].todouble() - (*y0)[i].todouble() ) ;
        }
        ++it1;
        j++;
        
    }
    
    // Get determinant of DZ
    double det;
    
    bool success = NOMAD::getDeterminant(V, det , dim);
    
    for ( size_t i = 0; i < dim ; i++ )
        delete [] V[i];
    delete [] V;
    
    if ( success )
    {
        NOMAD::OutputQueue::Add("The determinant of the matrix: det( [(y1-y0) (y2-y0) ... (ynf-y0)] ) = " + std::to_string(det), NOMAD::OutputLevel::LEVEL_DEBUG);
        
        double nfact = 1;

        // !n
        for ( size_t i=2 ; i < dim+1 ; i++)
        {
            nfact*=i;
        }
        
        _simplexVol = fabs(det) / nfact;  // Use fact(n) for volume
        
        if ( _simplexDiam > 0 )
            _simplexVon = _simplexVol / pow(_simplexDiam,dim) ;
        else
        {
            NOMAD::OutputQueue::Add("Cannot get the normalized volume of simplex Y because simplex diameter <=0. Let's continue. ", NOMAD::OutputLevel::LEVEL_DEBUG);
            return;
        }
    }
    else
    {
        NOMAD::OutputQueue::Add("Cannot get the volume of simplex Y because determinant failed. Continue", NOMAD::OutputLevel::LEVEL_DEBUG);
    }
    return ;
}


/*---------------------------------------------------------*/
/*---------------------------------------------------------*/
void NOMAD::NMIterationUtils::updateYDiameter()
{
    std::set<NOMAD::EvalPoint>::const_iterator it1;
    std::set<NOMAD::EvalPoint>::iterator it2;
    
    _simplexDiam = 0;
    for (it1 = _nmY->begin(); it1 != _nmY->end(); ++it1)
    {
        it2 = it1;
        ++it2;
        while ( it2 != _nmY->end() )
        {
            const NOMAD::Direction DZ((*it1) - (*it2));
            const double lengthDZ = DZ.norm().todouble();
            
            if ( lengthDZ > _simplexDiam )
            {
                _simplexDiam = lengthDZ;
                _simplexDiamPt1 = &(*it1);
                _simplexDiamPt2 = &(*it2);
            }
            ++it2;
        }
    }
    
    return ;
}


/*---------------------------------------------------------*/
/*---------------------------------------------------------*/
void NOMAD::NMIterationUtils::displayYInfo()const
{
    if ( nullptr == _nmY )
        NOMAD::Exception(__FILE__, __LINE__, "The iteration utils must have a simplex to work with");
    
    NOMAD::OutputInfo dbgInfo("NM iteration utils", "", NOMAD::OutputLevel::LEVEL_DEBUG );
    
    _parentStep->AddOutputInfo("Number of points in the simplex Y: " + std::to_string(_nmY->size()) );
    
    if ( _simplexVol > 0 )
        dbgInfo.addMsg("The volume of the simplex: " + std::to_string( _simplexVol ) );
    else
        dbgInfo.addMsg("WARNING: Evaluation of the simplex volume failed.");
    
    if ( _simplexDiam > 0 )
        dbgInfo.addMsg("The diameter of the simplex: " + std::to_string( _simplexDiam ) );
    else
        dbgInfo.addMsg( "WARNING: Evaluation of the simplex diameter failed.");
    
    if ( _simplexVon > 0 )
        dbgInfo.addMsg("The normalized volume of the simplex: " + std::to_string( _simplexVon ) );
    else
        dbgInfo.addMsg( "WARNING: Evaluation of the simplex normalized volume failed." );
    
    std::set<NOMAD::EvalPoint>::iterator itY;
    dbgInfo.addMsg("The simplex Y contains: ");
    for (itY =_nmY->begin(); itY != _nmY->end(); ++itY)
    {
        dbgInfo.addMsg( (*itY).display()) ;
    }
    getRankDZ();
    
    
    NOMAD::OutputQueue::Add(std::move(dbgInfo));
    NOMAD::OutputQueue::Flush();
}
